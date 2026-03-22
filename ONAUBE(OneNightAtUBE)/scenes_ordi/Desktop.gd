extends Control

@onready var cams=$cams


func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	pass

		
func _on_texture_button_2_pressed() -> void:
	cams.visible=true

func _on_texture_button_3_pressed() -> void:
	GameState.IG=true
	
	

		
		
		
		
