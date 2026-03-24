extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.time=0
	GameState.IG=false
	GameState.loose=false
	GameState.win=false
	GameState.on_pc=false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
