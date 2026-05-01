extends Control

@onready var new_game_button: Button = $CenterPanel/MenuVBox/NewGame

func _ready() -> void:
	new_game_button.grab_focus()
	GameState.en_menu=true
	AudioManager.play_menu_music()
	
	
func _on_nouvelle_partie_pressed():
	AudioManager.play_ui_click()
	get_tree().change_scene_to_file("res://final.tscn")
	
	

func _on_quitter_pressed():
	AudioManager.play_ui_click()
	get_tree().quit()

func _on_button_pressed() -> void:
	AudioManager.play_ui_click()
	get_tree().change_scene_to_file("res://final.tscn")
	
func _on_button_2_pressed() -> void:
	AudioManager.play_ui_click()
	get_tree().quit()
