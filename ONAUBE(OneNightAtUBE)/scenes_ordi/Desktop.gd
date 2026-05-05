extends Control

@onready var cams = $cams
@onready var robots = $Robots
@onready var minijeu = $MJ 
@onready var subMJ=$MJ/SubViewportContainer
@onready var light=get_node("../../DirectionalLight3D")

var mini_game_instance = null

func _process(delta: float) -> void:
	pass

# Bouton robots
func _on_texture_button_pressed() -> void:
	AudioManager.play_ui_click()
	robots.visible = true

# Bouton cams
func _on_texture_button_2_pressed() -> void:
	AudioManager.play_ui_click()
	light.visible=true
	cams.visible = true

# Bouton mini-jeu
func _on_texture_button_3_pressed() -> void:
	if 1 in GameState.activated_minigames:
		AudioManager.play_ui_click()
		var focus_owner := get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()

		minijeu.visible = true
		subMJ.open_minigame()
		GameState.IG=true
	else:
		print("MJ non disponible")
