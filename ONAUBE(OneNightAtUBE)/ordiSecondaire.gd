extends Node3D
var player

@onready var minijeu=$MJ
@onready var subMJ=$MJ/SubViewportContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and GameState.on_pc and player:
		
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		GameState.on_pc=false
		minijeu.visible=false
		GameState.IGV=false
		GameState.IGJ=false
		GameState.IGC=false
		
		
		
	
		


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		GameState.on_pc=true
		call_deferred("open_computer")
		
		



func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player=null
		GameState.on_pc=false
		
		

func open_computer():
	minijeu.visible=true
	subMJ.open_minigame()
	
