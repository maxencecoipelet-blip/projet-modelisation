extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.3

var respawn_position = Vector3(0, 2, 0)

var active=false


func set_active(value):
	active = value
	GameState.IG=true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	




func _physics_process(delta: float) -> void:
	if GameState.IG:
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		
		var direction = Vector3.ZERO

		if Input.is_action_pressed("ui_up"):
			direction -= transform.basis.z
		if Input.is_action_pressed("ui_down"):
			direction += transform.basis.z
		if Input.is_action_pressed("ui_left"):
			direction -= transform.basis.x
		if Input.is_action_pressed("ui_right"):
			direction += transform.basis.x

		direction = direction.normalized()

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		if global_position.y < -5:
			global_position = respawn_position
			velocity = Vector3.ZERO

		move_and_slide()


var mouse_sensitivity = 0.002
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Head.rotate_x(-event.relative.y * mouse_sensitivity)

		# limite la rotation verticale
		$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-80), deg_to_rad(80))
