extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.time=0
	GameState.IG=false
	GameState.loose=false
	GameState.win=false
	GameState.on_pc=false
	GameState.en_menu=false
	
	
