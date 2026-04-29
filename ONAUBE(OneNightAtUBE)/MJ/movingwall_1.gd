extends AnimatableBody3D

@export var move_distance := 4.0
@export var move_speed := 3.0

var start_position: Vector3
var time := 0.0

func _ready():
	start_position = global_position

func _physics_process(delta):
	time += delta
	global_position = start_position + Vector3(sin(time * move_speed) * move_distance, 0, 0)
