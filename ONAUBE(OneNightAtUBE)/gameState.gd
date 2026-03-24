extends Node
var time=0
var night_duration=60
var win=false
var IG=false
var IGJ=false
var IGV=false
var IGC=false

var loose=false
var on_pc=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time<=night_duration:
		time+=delta
	else:
		if !win:
			win=true
			call_deferred("win_game")
	print(IG, IGV, IGJ)

func get_current_hour():
	var ratio = time / night_duration
	var hour = int(ratio * 6)
	return clamp(hour, 0, 6)
	
	
	
func win_game():
	if !loose:
		get_tree().change_scene_to_file("res://ecran_win.tscn")
	
