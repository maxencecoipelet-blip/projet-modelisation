extends CharacterBody3D

const ANIM_WALK    := "mixamo_com"
const ANIM_JETPACK := "jetpack"

@export var walk_speed           := 6.0
@export var acceleration         := 14.0
@export var friction             := 12.0
@export var jump_velocity        := 7.0
@export var jetpack_force        := 20.0
@export var jetpack_max_fuel     := 3.0
@export var jetpack_regen_rate   := 0.9
@export var jetpack_consume_rate := 1.0
@export var cam_sens_x           := 0.2
@export var cam_sens_y           := 0.15
@export var cam_min_pitch        := -40.0
@export var cam_max_pitch        := 60.0

@onready var cam_root     : Node3D         = $CamRoot
@onready var spring_arm   : SpringArm3D    = $CamRoot/SpringArm3D
@onready var model_pivot  : Node3D         = $ModelPivot
@onready var jp_particles : CPUParticles3D = $JetpackParticles
@onready var jp_light     : OmniLight3D    = $JetpackLight

var anim_player   : AnimationPlayer = null
var gravity       : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _fuel         : float
var _jetpack_on   : bool   = false
var _cam_pitch    : float  = 0.0
var _current_anim : String = ""


func _ready() -> void:
	add_to_group("player")
	JetpackManager.player = self
	_fuel = jetpack_max_fuel
	if jp_particles: jp_particles.emitting = false
	if jp_light:     jp_light.visible      = false
	anim_player = _find_anim_player(model_pivot)
	if anim_player:
		anim_player.stop()


func _find_anim_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node as AnimationPlayer
	for child in node.get_children():
		var r := _find_anim_player(child)
		if r: return r
	return null


func _input(event: InputEvent) -> void:
	if JetpackManager.game_over: return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		cam_root.rotation_degrees.y -= event.relative.x * cam_sens_x
		_cam_pitch = clamp(_cam_pitch - event.relative.y * cam_sens_y, cam_min_pitch, cam_max_pitch)
		spring_arm.rotation_degrees.x = _cam_pitch


func _physics_process(delta: float) -> void:
	if JetpackManager.game_over: return
	_move(delta)
	_jetpack(delta)
	_animate()
	move_and_slide()


func _move(delta: float) -> void:
	if not is_on_floor() and not _jetpack_on:
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var raw := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).limit_length(1.0)

	var forward := -cam_root.global_transform.basis.z
	var right   :=  cam_root.global_transform.basis.x
	forward.y = 0.0
	right.y   = 0.0
	forward   = forward.normalized()
	right     = right.normalized()

	var wish := (forward * -raw.y + right * raw.x)
	var speed := walk_speed

	if wish.length() > 0.01:
		velocity.x = move_toward(velocity.x, wish.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, wish.z * speed, acceleration * delta)
		var target_yaw := atan2(wish.x, wish.z)
		model_pivot.rotation.y = lerp_angle(model_pivot.rotation.y, target_yaw, 10.0 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		velocity.z = move_toward(velocity.z, 0.0, friction * delta)


func _jetpack(delta: float) -> void:
	var trying := Input.is_action_pressed("ui_accept") and not is_on_floor()
	if trying and _fuel > 0.0:
		_jetpack_on = true
		velocity.y  = move_toward(velocity.y, jetpack_force * 0.75, jetpack_force * delta)
		_fuel       = max(_fuel - jetpack_consume_rate * delta, 0.0)
	else:
		_jetpack_on = false
		if is_on_floor():
			_fuel = min(_fuel + jetpack_regen_rate * delta, jetpack_max_fuel)
	if jp_particles: jp_particles.emitting = _jetpack_on
	if jp_light:
		jp_light.visible = _jetpack_on
		if _jetpack_on: jp_light.light_energy = randf_range(1.6, 2.8)


func _animate() -> void:
	if not anim_player: return
	var is_moving := Input.is_action_pressed("ui_up") or \
					 Input.is_action_pressed("ui_down") or \
					 Input.is_action_pressed("ui_left") or \
					 Input.is_action_pressed("ui_right")

	var in_air := not is_on_floor() or velocity.y > 0.5

	var next := ANIM_JETPACK if _jetpack_on else ANIM_WALK if (is_moving and not in_air) else ""
	if next == _current_anim: return
	_current_anim = next
	if next == "":
		anim_player.stop()
	elif anim_player.has_animation(next):
		anim_player.play(next)


func get_fuel_ratio() -> float:
	return _fuel / jetpack_max_fuel
