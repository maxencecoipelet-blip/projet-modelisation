extends CharacterBody3D
@export var mouse_sensitivity := 0.003
var camera_x_rotation := 0.0
const SPEED = 4
const JUMP_VELOCITY = 2.5

@onready var camera_pivot = get_node("CameraPivot")
@export var rotationstep=-0.05
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("Camera pivot =", camera_pivot)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("ui_cancel"):
		position=Vector3(0,1,0)
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
func _input(event):
	if event is InputEventMouseMotion:
		# Rotation gauche / droite (joueur)
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Rotation haut / bas (camera)
		camera_x_rotation -= event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation, deg_to_rad(-80), deg_to_rad(80))

		camera_pivot.rotation.x = camera_x_rotation
	
