extends Node3D
var player

@onready var desktop=$Desktop
@onready var cams=$Desktop/cams
@onready var robots=$Desktop/Robots
@onready var minijeu=$Desktop/MJ
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and GameState.on_pc and player:
		if cams.visible or robots.visible or minijeu.visible:
			desktop.visible=true
			cams.visible=false
			robots.visible=false
			minijeu.visible=false
			GameState.IG=false
			
			
		else:
			desktop.visible=false
			GameState.on_pc=false
			GameState.IG=false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		
		
		
	
		


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		GameState.on_pc=true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		call_deferred("open_computer")
		
			
		



func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player=null
		GameState.on_pc=false
		
		

func open_computer():
	$Desktop.visible=true
	
