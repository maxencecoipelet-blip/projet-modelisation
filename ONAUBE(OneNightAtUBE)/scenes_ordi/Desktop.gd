extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$VBoxContainer/TextureButton.grab_focus()


func _on_texture_button_pressed() -> void:
	print("hey")


func _on_texture_button_2_pressed() -> void:
	pass 


func _on_texture_button_3_pressed() -> void:
	pass
