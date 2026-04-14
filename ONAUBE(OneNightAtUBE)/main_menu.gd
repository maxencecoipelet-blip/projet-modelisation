extends Control

@onready var new_game_button: Button = $CenterPanel/MenuVBox/NewGame

func _ready() -> void:
	new_game_button.grab_focus()
func _on_nouvelle_partie_pressed():
	get_tree().change_scene_to_file("res://final.tscn")
	
	

func _on_quitter_pressed():
	
	get_tree().quit()
