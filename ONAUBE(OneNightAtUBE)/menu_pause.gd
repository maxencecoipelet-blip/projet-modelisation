extends CanvasLayer

var pause = false
@onready var reprendre_button: Button = $CenterPanel/MenuVBox/Reprendre

func _input(event):
	if event.is_action_pressed("pause") and !GameState.on_pc:
		toggle_pause()

func toggle_pause():
	pause = !pause
	if pause:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		show()
		await get_tree().process_frame
		reprendre_button.grab_focus()
	else:
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false

func _on_main_pressed() -> void:
	toggle_pause()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_reprendre_pressed() -> void:
	toggle_pause()

func _on_parametres_pressed() -> void:
	toggle_pause()
	get_tree().change_scene_to_file("res://SettingsMenu.tscn")
