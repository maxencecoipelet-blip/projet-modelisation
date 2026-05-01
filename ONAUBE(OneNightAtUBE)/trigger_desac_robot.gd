extends Area3D
@export var target_robot_name := "robot"

var triggered := false

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if triggered:
		return
	if not body is CharacterBody3D:
		return
	triggered = true
	GameState.disable_robot(target_robot_name)
	set_deferred("monitoring", false)
	call_deferred("queue_free")
