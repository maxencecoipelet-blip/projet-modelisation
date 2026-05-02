extends CharacterBody3D

var speed = 3.0
var player = null
var chasing = false
var target_position = Vector3.ZERO
@export var time_active=0
@export var robot_id := ""
var is_active=false
var is_disabled := false
var robot_move_threshold := 0.15
var robot_stop_delay := 0.6
var robot_stop_timer := 0.0

@onready var bruit_robot = $BruitRobot
@onready var shutdown_sound = get_node_or_null("ShutdownSound")
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D


func _process(delta: float) -> void:
	if is_disabled:
		return
	if GameState.get_current_hour()>=time_active:
		is_active=true
	
	
func _ready():
	_restore_default_visual()
	if robot_id.is_empty():
		robot_id = name
	if GameState.is_robot_disabled(robot_id):
		disable_robot()
		return
	choose_random_position()

func _physics_process(delta):
	if is_disabled:
		return

	if chasing and player and is_active:
		target_position = player.global_position

	var direction = (target_position - global_position).normalized()
	if chasing:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	elif is_active and !chasing:
		velocity.x = direction.x * speed/2
		velocity.z = direction.z * speed/2

	

	if global_position.distance_to(target_position) < 1.5 and !chasing:
		choose_random_position()
	move_and_slide()
	_update_robot_audio(delta)
	
func choose_random_position():
	target_position = Vector3(
		randf_range(-5,5),
		global_position.y,
		randf_range(-5,5)
	)

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
