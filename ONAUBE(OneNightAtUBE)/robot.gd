extends CharacterBody3D

var speed = 3.0
var player = null
var chasing = false
var target_position = Vector3.ZERO
@export var time_active=0
@export var robot_id := ""
@export var patrol_bounds_min := Vector3(-140.0, 0.0, -90.0)
@export var patrol_bounds_max := Vector3(230.0, 0.0, 230.0)


var is_active=false
#detecte la premiere fois que is_active passe en true
var has_activated=false


var is_disabled := false
var robot_move_threshold := 0.15
var robot_stop_delay := 0.6
var robot_stop_timer := 0.0

@onready var bruit_robot = $BruitRobot
@onready var shutdown_sound = get_node_or_null("ShutdownSound")
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D


func _process(delta: float) -> void:
	if is_disabled:
		return

	if GameState.get_current_hour() >= time_active and !has_activated:
		is_active = true
		has_activated = true
		
		#  Tirage aléatoire UNE SEULE FOIS
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var nombre = rng.randi_range(1, 4)
		while nombre in GameState.activated_minigames:
			nombre = rng.randi_range(1, 4)
		GameState.activated_minigames.append(nombre)
		print(GameState.activated_minigames)
	
	
func _ready():
	_restore_default_visual()
	if robot_id.is_empty():
		robot_id = name
	navigation_agent.max_speed = speed
	if GameState.is_robot_disabled(robot_id):
		disable_robot()
		return
	choose_random_position()

func _physics_process(delta):
	if is_disabled:
		return

	if chasing and player and is_active:
		_set_navigation_target(player.global_position)
	elif is_active and !chasing and navigation_agent.is_navigation_finished():
		choose_random_position()

	var current_speed := 0.0
	if chasing and is_active:
		current_speed = speed
	elif is_active and !chasing:
		current_speed = speed / 2.0

	if current_speed > 0.0 and not navigation_agent.is_navigation_finished():
		var next_path_position := navigation_agent.get_next_path_position()
		var direction := next_path_position - global_position
		direction.y = 0.0
		if direction.length() > 0.05:
			direction = direction.normalized()
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
	_update_robot_audio(delta)
	
func choose_random_position():
	var random_target := Vector3(
		randf_range(patrol_bounds_min.x, patrol_bounds_max.x),
		global_position.y,
		randf_range(patrol_bounds_min.z, patrol_bounds_max.z)
	)
	_set_navigation_target(random_target)


func _set_navigation_target(desired_target: Vector3) -> void:
	var navigation_map_rid := get_world_3d().navigation_map
	var snapped_target := desired_target
	if navigation_map_rid.is_valid():
		snapped_target = NavigationServer3D.map_get_closest_point(navigation_map_rid, desired_target)
	target_position = snapped_target
	navigation_agent.target_position = snapped_target
	
	
	
	
	

func _on_area_3d_body_entered(body):
	if is_disabled:
		return
	if is_active and body.is_in_group("player"):
		player = body
		if not chasing:
			chasing = true
			AudioManager.notify_robot_started_chase()



func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if is_disabled:
		return
	if is_active and body.is_in_group("player"):
		if chasing:
			chasing = false
			AudioManager.notify_robot_stopped_chase()
		choose_random_position()
		player = null



func _on_area_3d_3_body_entered(body: Node3D) -> void:
	if is_disabled:
		return
	if is_active:
		if body.is_in_group("player"):
			GameState.loose=true
			call_deferred("triggerMort")
			
			
			
			
			
			
func triggerMort():
	if chasing:
		chasing = false
		AudioManager.notify_robot_stopped_chase()
	get_tree().change_scene_to_file("res://ecran_mort.tscn")

func _update_robot_audio(delta: float) -> void:
	if not is_active:
		if bruit_robot.playing:
			bruit_robot.stop()
		robot_stop_timer = 0.0
		return

	var is_moving := Vector2(velocity.x, velocity.z).length() > robot_move_threshold
	if is_moving:
		robot_stop_timer = robot_stop_delay
		if not bruit_robot.playing:
			bruit_robot.play()
	else:
		robot_stop_timer = max(robot_stop_timer - delta, 0.0)
		if bruit_robot.playing and robot_stop_timer <= 0.0:
			bruit_robot.stop()
			
			
			

func disable_robot() -> void:
	if is_disabled:
		return
	var was_chasing: bool = chasing
	is_disabled = true
	is_active = false
	chasing = false
	player = null
	velocity = Vector3.ZERO
	navigation_agent.target_position = global_position
	robot_stop_timer = 0.0
	if was_chasing:
		AudioManager.notify_robot_stopped_chase()
	if bruit_robot.playing:
		bruit_robot.stop()
	if shutdown_sound:
		shutdown_sound.play()
	for area_name in ["Area3D", "Area3D2", "Area3D3"]:
		var area = get_node_or_null(area_name)
		if area:
			area.set_deferred("monitoring", false)
			area.set_deferred("monitorable", false)
			var area_shape = area.get_node_or_null("CollisionShape3D")
			if area_shape:
				area_shape.set_deferred("disabled", true)
	set_process(false)
	set_physics_process(false)
	_apply_disabled_visual()

func can_be_disabled_by_minigame() -> bool:
	return is_active and not is_disabled

func _apply_disabled_visual() -> void:
	if not mesh_instance:
		return
	var disabled_material := StandardMaterial3D.new()
	disabled_material.albedo_color = Color(0.9, 0.15, 0.15, 1.0)
	disabled_material.emission_enabled = true
	disabled_material.emission = Color(0.55, 0.05, 0.05, 1.0)
	disabled_material.emission_energy_multiplier = 1.2
	mesh_instance.material_override = disabled_material

func _restore_default_visual() -> void:
	if mesh_instance:
		mesh_instance.material_override = null
