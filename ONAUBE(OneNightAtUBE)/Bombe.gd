extends Area3D

@export var position_respawn := Vector3(5.897, -46.149, -61.492)
@export var rotation_respawn_y := -90.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("voiture"):
		return
	
	print("Bombe touchée !")
	
	# Téléporte la voiture
	body.global_position = position_respawn
	# Reset complet de la rotation (évite que la voiture spawn penchée)
	body.rotation = Vector3(0, deg_to_rad(rotation_respawn_y), 0)
	
	# Reset de la vitesse
	if "vitesse_actuelle" in body:
		body.vitesse_actuelle = 0.0
	if "velocity_horizontale" in body:
		body.velocity_horizontale = Vector3.ZERO
	body.velocity = Vector3.ZERO
