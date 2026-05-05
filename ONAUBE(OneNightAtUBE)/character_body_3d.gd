extends CharacterBody3D
@export var mouse_sensitivity := 0.003
var camera_x_rotation := 0.0
const SPEED = 4
const JUMP_VELOCITY = 2.5

var step_timer := 0.0
var step_interval := 1
var step_restart_delay := 0.12
var was_walking := false


@onready var camera_pivot = get_node("CameraPivot")
@onready var bruit_pas = $"../BruitPas"
@export var rotationstep=-0.05
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !GameState.on_pc and !GameState.IG:
		
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		move_and_slide()
		_handle_footsteps(delta)
	else:
		if was_walking:
			step_timer = step_restart_delay
		was_walking = false

func _input(event):
	if event is InputEventMouseMotion and !GameState.on_pc:
		# Rotation gauche / droite (joueur)
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Rotation haut / bas (camera)
		camera_x_rotation -= event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation, deg_to_rad(-80), deg_to_rad(80))

		camera_pivot.rotation.x = camera_x_rotation

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
	
