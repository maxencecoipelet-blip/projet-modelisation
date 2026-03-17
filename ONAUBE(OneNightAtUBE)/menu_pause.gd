extends CanvasLayer
var pause = false

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()
		
	

func toggle_pause():
	pause=!pause
	
	if pause:
		#get_tree().current_scene.call("save_current_state")
		get_tree().paused=true
		show()
		await get_tree().process_frame
		$Label/VBoxContainer/Reprendre.grab_focus()
	else:
		hide()
		get_tree().paused=false
		



func _on_main_pressed() -> void:
	toggle_pause()
	#get_tree().current_scene.call("save_current_state")
	#GameState.save_game()
	
	get_tree().change_scene_to_file("res://scenes.global/MainMenu.tscn")


func _on_reprendre_pressed() -> void:
	toggle_pause()


func _on_paramètres_pressed() -> void:
	toggle_pause()
	#GameState.IG=true
	get_tree().change_scene_to_file("res://scenes.global/SettingsMenu.tscn")
