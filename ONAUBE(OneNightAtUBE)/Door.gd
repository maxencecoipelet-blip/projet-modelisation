extends Area3D

@export var door_choice: String = "a"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("culture_player"):
		GameManager.answer(door_choice)
