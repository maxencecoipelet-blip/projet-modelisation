extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 3.9
const MOUSE_SENSITIVITY = 0.002

var respawn_position = Vector3(0, 2, 0)
var active = false
var step_timer := 0.0
var step_interval := 0.7
var step_restart_delay := 0.12
var was_walking := false

@onready var bruit_pas = $BruitPas


func _ready():
	set_active(true)
	print(Engine.get_frames_per_second())
	
	
func set_active(value: bool) -> void:
	active = value
	GameState.IG = value
	if value:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
	if not active or not GameState.IG:
		was_walking = false
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if global_position.y < -5:
		global_position = respawn_position
		velocity = Vector3.ZERO

	move_and_slide()
	_handle_footsteps(delta)


func _unhandled_input(event: InputEvent) -> void:
	if not active or not GameState.IG:
		return

	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		$Head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _handle_footsteps(delta: float) -> void:
	var real_velocity := get_real_velocity()
	var horizontal_speed := Vector2(real_velocity.x, real_velocity.z).length()
	var is_walking := is_on_floor() and horizontal_speed > 0.02
	if not is_walking:
		if was_walking:
			step_timer = min(step_timer if step_timer > 0.0 else step_restart_delay, step_restart_delay)
		was_walking = false
		return

	if not was_walking and step_timer <= 0.0:
		bruit_pas.play()
		step_timer = step_interval
		was_walking = true
		return

	was_walking = true
	step_timer -= delta
	if step_timer <= 0.0:
		bruit_pas.play()
		step_timer = step_interval
