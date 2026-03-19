extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$VBoxContainer/TextureButton.grab_focus()


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes_ordi/UIRobots.tscn")


func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes_ordi/caméras.tscn")


func _on_texture_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes_ordi/minijeu.tscn")
	

		
		
		
		
