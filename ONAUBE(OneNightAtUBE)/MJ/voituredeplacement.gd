extends CharacterBody3D

# === REGLAGES (modifiables dans l'inspecteur) ===
@export_group("Vitesse")
@export var vitesse_max := 25.0
@export var vitesse_max_boost := 70.0
@export var vitesse_max_arriere := 10.0
@export var acceleration := 30.0
@export var freinage := 25.0
@export var friction := 8.0

@export_group("Direction")
@export var vitesse_rotation := 2.5
@export var glissade := 6.0

@export_group("Physique")
@export var gravite := 25.0

# === VARIABLES INTERNES ===
var vitesse_actuelle := 0.0
var velocity_horizontale := Vector3.ZERO


func _physics_process(delta: float) -> void:
	_gerer_conduite(delta)
	move_and_slide()


func _gerer_conduite(delta: float) -> void:
		# === Inputs ===
		var input_avant := Input.get_action_strength("ui_up")
		var input_arriere := Input.get_action_strength("ui_down")
		var input_gauche := Input.get_action_strength("ui_left")
		var input_droite := Input.get_action_strength("ui_right")
		var boost_actif := Input.is_action_pressed("ui_select")
		
		# === Accélération / Freinage ===
		var vmax := vitesse_max_boost if boost_actif else vitesse_max
		
		if input_avant > 0:
			if vitesse_actuelle < 0:
				vitesse_actuelle += freinage * delta
			else:
				vitesse_actuelle += acceleration * input_avant * delta
			vitesse_actuelle = min(vitesse_actuelle, vmax)
		elif input_arriere > 0:
			if vitesse_actuelle > 0:
				vitesse_actuelle -= freinage * delta
			else:
				vitesse_actuelle -= acceleration * input_arriere * delta * 0.7
			vitesse_actuelle = max(vitesse_actuelle, -vitesse_max_arriere)
		else:
			vitesse_actuelle = move_toward(vitesse_actuelle, 0.0, friction * delta)
		
		# === Direction ===
		var direction_input := input_gauche - input_droite
		if abs(vitesse_actuelle) > 0.5:
			var facteur_vitesse: float = clamp(abs(vitesse_actuelle) / vitesse_max, 0.3, 1.0)
			var sens: float = sign(vitesse_actuelle)
			rotate_y(direction_input * vitesse_rotation * facteur_vitesse * sens * delta)
		
		# === Mouvement avec glissade arcade ===
		var direction_voiture := -transform.basis.z
		var velocity_voulue := direction_voiture * vitesse_actuelle
		velocity_horizontale = velocity_horizontale.lerp(velocity_voulue, glissade * delta)
		
		# === Gravité ===
		if not is_on_floor():
			velocity.y -= gravite * delta
		else:
			velocity.y = -1.0
		
		# === Application finale ===
		velocity.x = velocity_horizontale.x
		velocity.z = velocity_horizontale.z
