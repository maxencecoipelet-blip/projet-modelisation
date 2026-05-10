extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "voiture":
		body.vitesse_max = 5.0

func _on_body_exited(body: Node3D) -> void:
	if body.name == "voiture":
		body.vitesse_max = 25.0
