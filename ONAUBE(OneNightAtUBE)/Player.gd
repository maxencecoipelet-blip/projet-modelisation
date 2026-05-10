extends CharacterBody3D

@export var speed: float = 8.0
@export var mouse_sensitivity: float = 0.002

var step_timer := 0.0
var step_interval := 0.7
var step_restart_delay := 0.12
var was_walking := false

@onready var camera: Camera3D = $Camera3D
@onready var bruit_pas = $BruitPas

func _ready():
	add_to_group("culture_player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# rotation gauche/droite (player)
		rotate_y(-event.relative.x * mouse_sensitivity)

		# rotation haut/bas (camera)
		var new_x = camera.rotation.x - event.relative.y * mouse_sensitivity
		camera.rotation.x = clamp(new_x, deg_to_rad(-80), deg_to_rad(80))

	# touche echap pour libérer la souris
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	# gravité
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	# déplacements
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	_handle_footsteps(delta)

func reset_position():
	global_position = Vector3(0, 1, 0)
	rotation = Vector3.ZERO
	camera.rotation = Vector3.ZERO
	velocity = Vector3.ZERO
	step_timer = 0.0
	was_walking = false

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
