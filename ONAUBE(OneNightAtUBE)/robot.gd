extends CharacterBody3D

var speed = 3.0
var player = null
var chasing = false
var target_position = Vector3.ZERO
@export var time_active=0
var is_active=false


func _process(delta: float) -> void:
	if GameState.get_current_hour()>=time_active:
		is_active=true
	
	
func _ready():
	choose_random_position()

func _physics_process(delta):

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
	
func choose_random_position():
	target_position = Vector3(
		randf_range(-5,5),
		global_position.y,
		randf_range(-5,5)
	)

func _on_area_3d_body_entered(body):
	if is_active:
		if body.is_in_group("player"):
			player = body
			chasing = true


func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if is_active:
		if body.is_in_group("player"):
			
			chasing=false
			choose_random_position()
			
			player=null
