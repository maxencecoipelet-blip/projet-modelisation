extends Control

@onready var cams=$cams
@onready var robots=$Robots


func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	robots.visible=true

		
func _on_texture_button_2_pressed() -> void:
	cams.visible=true

func _on_texture_button_3_pressed() -> void:
	GameState.IG=true
	
	

		
		
		
		
