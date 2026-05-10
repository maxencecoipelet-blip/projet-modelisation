extends CharacterBody3D

# ═══════════════════════════════════════════════════════════════════════════════
#  STATS
# ═══════════════════════════════════════════════════════════════════════════════
var speed := 3.0

@export var time_active := 0
@export var robot_id    := ""
@export var gravity     := 22.0


# ═══════════════════════════════════════════════════════════════════════════════
#  SYSTÈME DE WAYPOINTS
# ═══════════════════════════════════════════════════════════════════════════════
@export var waypoints_parent_path : NodePath = NodePath("../waypoints")
@export var connection_radius     : float    = 16.0

const WP_REACH      := 1.4
const CHASE_CLOSE   := 4.0
const STUCK_TIMEOUT := 1.8

var _wps  : Array = []
var _adj  : Array = []
var _path : Array = []
var _cur  : int   = -1

var _stuck_timer    : float   = 0.0
var _last_pos       : Vector3 = Vector3.ZERO
var _stuck_attempts : int     = 0
const STUCK_CHECK   := 0.8
const STUCK_DIST    := 0.3
var _stuck_check_timer : float = 0.0

# ═══════════════════════════════════════════════════════════════════════════════
#  INTELLIGENCE DE CHASSE
# ═══════════════════════════════════════════════════════════════════════════════
var player        : Node3D = null
var chasing       := false
var last_known    := Vector3.ZERO
var _search_timer := 0.0
const SEARCH_DUR  := 9.0
var _repath_timer : float = 0.0
const REPATH_INTERVAL := 0.4

# ═══════════════════════════════════════════════════════════════════════════════
#  ÉTAT GÉNÉRAL
# ═══════════════════════════════════════════════════════════════════════════════
var is_active     := false
var has_activated := false
var is_disabled   := false

var robot_move_threshold := 0.15
var robot_stop_delay     := 0.6
var robot_stop_timer     := 0.0

@onready var bruit_robot      = $BruitRobot
@onready var shutdown_sound   = get_node_or_null("ShutdownSound")
@onready var mesh_instance    : MeshInstance3D = get_node_or_null("MeshInstance3D")

# ── ANIMATION ──────────────────────────────────────────────────────────────────
# On cherche l'AnimationPlayer dans le GLB importé (LEROBOT/AnimationPlayer)
@onready var anim_player : AnimationPlayer = get_node_or_null("LEROBOT/AnimationPlayer")

## Mets ici le nom EXACT de ton animation de marche tel qu'il apparaît
## dans l'AnimationPlayer (ex: "mixamo_com", "walk", "Armature|walk"…)
@export var anim_walk : String = "mixamo_com"
@export var anim_idle : String = ""   # laisse vide si t'as pas d'idle


# ═══════════════════════════════════════════════════════════════════════════════
#  INITIALISATION
# ═══════════════════════════════════════════════════════════════════════════════
func _ready() -> void:
	_restore_default_visual()
	if anim_player:
		anim_player.stop()   
	if robot_id.is_empty():
		robot_id = name
	if GameState.is_robot_disabled(robot_id):
		disable_robot()
		return
	_build_waypoint_graph()
	_go_to_random_wp()
	_last_pos = global_position


func _build_waypoint_graph() -> void:
	_wps.clear()
	_adj.clear()

	if not waypoints_parent_path.is_empty():
		var parent = get_node_or_null(waypoints_parent_path)
		if parent:
			for child in parent.get_children():
				if child is Node3D:
					_wps.append(child)

	if _wps.is_empty():
		push_warning("Robot [%s] : aucun waypoint trouvé ! Vérifiez waypoints_parent_path." % robot_id)
		return

	_adj.resize(_wps.size())
	for i in _wps.size():
		_adj[i] = []

	for i in _wps.size():
		for j in range(i + 1, _wps.size()):
			if _wps[i].global_position.distance_to(_wps[j].global_position) <= connection_radius:
				_adj[i].append(j)
				_adj[j].append(i)


# ═══════════════════════════════════════════════════════════════════════════════
#  ACTIVATION
# ═══════════════════════════════════════════════════════════════════════════════
func _process(delta: float) -> void:
	if is_disabled:
		return
	if GameState.get_current_hour() >= time_active and not has_activated:
		is_active      = true
		has_activated  = true
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var nombre = rng.randi_range(1, 4)
		while nombre in GameState.activated_minigames:
			nombre = rng.randi_range(1, 4)
		GameState.activated_minigames.append(nombre)
		print(GameState.activated_minigames)


# ═══════════════════════════════════════════════════════════════════════════════
#  PHYSIQUE
# ═══════════════════════════════════════════════════════════════════════════════
func _physics_process(delta: float) -> void:
	if is_disabled:
		return

	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= gravity * delta

	if not is_active:
		velocity.x = 0.0
		velocity.z = 0.0
		move_and_slide()
		_play_anim(false)   # arrêt animation si inactif
		return

	_stuck_check_timer += delta
	if _stuck_check_timer >= STUCK_CHECK:
		_stuck_check_timer = 0.0
		var dist_moved := global_position.distance_to(_last_pos)
		if dist_moved < STUCK_DIST:
			_stuck_attempts += 1
			_try_unstuck()
		else:
			_stuck_attempts = 0
		_last_pos = global_position

	var target_pos : Vector3
	var cur_speed  : float

	if chasing and player:
		last_known    = player.global_position
		_search_timer = SEARCH_DUR
		var dist = global_position.distance_to(player.global_position)
		

		_repath_timer -= delta                # ← AJOUT
		if _repath_timer <= 0.0:              # ← AJOUT
			_path.clear()                     # ← AJOUT : force BFS frais
			_repath_timer = REPATH_INTERVAL   # ← AJOUT

		if dist <= CHASE_CLOSE:
			target_pos = player.global_position
			_path.clear()
		else:
			target_pos = _next_waypoint_toward(player.global_position)
			cur_speed = speed
		if dist <= CHASE_CLOSE:
			target_pos = player.global_position
			_path.clear()
		else:
			target_pos = _next_waypoint_toward(player.global_position)
		cur_speed = speed

	elif _search_timer > 0.0:
		_search_timer -= delta
		target_pos = _next_waypoint_toward(last_known)
		cur_speed  = speed * 0.8
		if global_position.distance_to(last_known) < WP_REACH * 2.5 and _path.is_empty():
			_search_timer = 0.0
			_go_to_random_wp()

	else:
		target_pos = _patrol_next()
		cur_speed  = speed * 0.5

	var to_target := target_pos - global_position
	to_target.y   = 0.0

	if to_target.length() > 0.05:
		var dir    := to_target.normalized()
		velocity.x  = dir.x * cur_speed
		velocity.z  = dir.z * cur_speed
		var look_pos := global_position + to_target
		if look_pos.distance_to(global_position) > 0.01:
			var t := transform.looking_at(look_pos, Vector3.UP)
			transform.basis = transform.basis.slerp(t.basis, delta * 8.0)
		_play_anim(true)    # ← MARCHE
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		_play_anim(false)   # ← ARRÊT

	move_and_slide()
	_update_robot_audio(delta)


# ═══════════════════════════════════════════════════════════════════════════════
#  ANIMATION  (nouvelle fonction)
# ═══════════════════════════════════════════════════════════════════════════════
func _play_anim(walking: bool) -> void:
	if not anim_player:
		return
	if walking:
		if anim_player.current_animation != anim_walk:
			anim_player.play(anim_walk)
	else:
		if anim_idle != "" and anim_player.current_animation != anim_idle:
			anim_player.play(anim_idle)
		elif anim_idle == "" and anim_player.is_playing():
			anim_player.stop()


# ═══════════════════════════════════════════════════════════════════════════════
#  STUCK
# ═══════════════════════════════════════════════════════════════════════════════
func _try_unstuck() -> void:
	match _stuck_attempts:
		1:
			if _path.size() > 1:
				_path.pop_front()
			else:
				_go_to_random_wp()
		2:
			var rng_dir := Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
			velocity.x = rng_dir.x * speed * 2.0
			velocity.z = rng_dir.z * speed * 2.0
			velocity.y = 4.0
			_go_to_random_wp()
		3:
			var nearest := _nearest_wp(global_position)
			if nearest >= 0 and nearest < _wps.size():
				global_position = _wps[nearest].global_position + Vector3(0, 0.2, 0)
			_go_to_random_wp()
			_stuck_attempts = 0
		_:
			var nearest := _nearest_wp(global_position)
			if nearest >= 0 and nearest < _wps.size():
				global_position = _wps[nearest].global_position + Vector3(0, 0.2, 0)
			_go_to_random_wp()
			_stuck_attempts = 0


# ═══════════════════════════════════════════════════════════════════════════════
#  NAVIGATION WAYPOINTS (BFS)
# ═══════════════════════════════════════════════════════════════════════════════
func _next_waypoint_toward(dest: Vector3) -> Vector3:
	if not _path.is_empty():
		var next_pos : Vector3 = _wps[_path[0]].global_position
		if global_position.distance_to(next_pos) < WP_REACH:
			_cur = _path[0]
			_path.pop_front()

	if _path.is_empty():
		var from_idx := _nearest_wp(global_position)
		var to_idx   := _nearest_wp(dest)
		_path = _bfs(from_idx, to_idx)
		if not _path.is_empty():
			_path.pop_front()

	if not _path.is_empty():
		return _wps[_path[0]].global_position

	return dest


func _patrol_next() -> Vector3:
	if _path.is_empty():
		_go_to_random_wp()

	if _path.is_empty():
		return global_position

	var next_pos : Vector3 = _wps[_path[0]].global_position
	if global_position.distance_to(next_pos) < WP_REACH:
		_cur = _path[0]
		_path.pop_front()

	if _path.is_empty():
		return global_position

	return _wps[_path[0]].global_position


func _go_to_random_wp() -> void:
	if _wps.is_empty():
		return
	var from := _nearest_wp(global_position)
	var dest := randi() % _wps.size()
	var tries := 0
	while dest == from and tries < 10:
		dest = randi() % _wps.size()
		tries += 1
	_path = _bfs(from, dest)
	if not _path.is_empty():
		_path.pop_front()


func _nearest_wp(pos: Vector3) -> int:
	var best_idx  := 0
	var best_dist := INF
	for i in _wps.size():
		var d : float = _wps[i].global_position.distance_to(pos)
		if d < best_dist:
			best_dist = d
			best_idx  = i
	return best_idx


func _bfs(from_idx: int, to_idx: int) -> Array:
	if from_idx == to_idx or _adj.is_empty():
		return [from_idx]

	var queue   : Array      = [[from_idx]]
	var visited : Dictionary = {from_idx: true}

	while not queue.is_empty():
		var path : Array = queue.pop_front()
		var node : int   = path[-1]
		for neighbor : int in _adj[node]:
			if neighbor == to_idx:
				return path + [neighbor]
			if not visited.has(neighbor):
				visited[neighbor] = true
				queue.append(path + [neighbor])

	return [from_idx]


# ═══════════════════════════════════════════════════════════════════════════════
#  ZONES DE DÉTECTION
# ═══════════════════════════════════════════════════════════════════════════════
func _on_area_3d_body_entered(body) -> void:
	if is_disabled:
		return
	if is_active and body.is_in_group("player"):
		player = body
		if not chasing:
			chasing = true
			_path.clear()
			AudioManager.notify_robot_started_chase()


func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if is_disabled:
		return
	if is_active and body.is_in_group("player"):
		if chasing:
			chasing = false
			AudioManager.notify_robot_stopped_chase()
		_path.clear()
		player = null


func _on_area_3d_3_body_entered(body: Node3D) -> void:
	if is_disabled:
		return
	if is_active and body.is_in_group("player"):
		GameState.loose = true
		call_deferred("triggerMort")


func triggerMort() -> void:
	if chasing:
		chasing = false
		AudioManager.notify_robot_stopped_chase()
	get_tree().change_scene_to_file("res://ecran_mort.tscn")


# ═══════════════════════════════════════════════════════════════════════════════
#  AUDIO
# ═══════════════════════════════════════════════════════════════════════════════
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


# ═══════════════════════════════════════════════════════════════════════════════
#  DÉSACTIVATION
# ═══════════════════════════════════════════════════════════════════════════════
func disable_robot() -> void:
	if is_disabled:
		return
	var was_chasing := chasing
	is_disabled  = true
	is_active    = false
	chasing      = false
	player       = null
	velocity     = Vector3.ZERO
	_path.clear()
	robot_stop_timer = 0.0
	if was_chasing:
		AudioManager.notify_robot_stopped_chase()
	if bruit_robot.playing:
		bruit_robot.stop()
	if shutdown_sound:
		shutdown_sound.play()
	if anim_player and anim_player.is_playing():   # ← stop animation aussi
		anim_player.stop()
	for area_name in ["Area3D", "Area3D2", "Area3D3"]:
		var area = get_node_or_null(area_name)
		if area:
			area.set_deferred("monitoring",  false)
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
	var mat := StandardMaterial3D.new()
	mat.albedo_color              = Color(0.9, 0.15, 0.15, 1.0)
	mat.emission_enabled          = true
	mat.emission                  = Color(0.55, 0.05, 0.05, 1.0)
	mat.emission_energy_multiplier = 1.2
	mesh_instance.material_override = mat


func _restore_default_visual() -> void:
	if mesh_instance:
		mesh_instance.material_override = null
