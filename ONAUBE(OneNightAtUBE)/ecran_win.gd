extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameState.en_menu=true
	AudioManager.play_victory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_button_2_pressed() -> void:
	AudioManager.play_ui_click()
	get_tree().change_scene_to_file("res://MainMenu.tscn")
