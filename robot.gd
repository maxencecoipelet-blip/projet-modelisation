extends CharacterBody3D

var speed = 3.0
var player = null
var chasing = false
var target_position = Vector3.ZERO



func _ready():
	choose_random_position()

func _physics_process(delta):

	if chasing and player:
		target_position = player.global_position

	var direction = (target_position - global_position).normalized()
	if chasing:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = direction.x * speed/2
		velocity.z = direction.z * speed/2

	move_and_slide()

	if global_position.distance_to(target_position) < 1.5 and !chasing:
		choose_random_position()

func choose_random_position():
	target_position = Vector3(
		randf_range(-5,5),
		global_position.y,
		randf_range(-5,5)
	)

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		player = body
		chasing = true


func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		
		chasing=false
		choose_random_position()
		
		player=null
