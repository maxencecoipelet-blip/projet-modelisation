extends Node
var time=0
var night_duration=60
var win=false
var IG=false
var IGJ=false
var IGV=false
var IGC=false
var en_menu=false

var loose=false
var on_pc=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_configure_window")

func _configure_window() -> void:
	var root_window := get_tree().root
	root_window.content_scale_size = Vector2i(1920, 1080)
	root_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	root_window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	root_window.mode = Window.MODE_MAXIMIZED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time<=night_duration:
		time+=delta
	else:
		if !win and !en_menu:
			win=true
			call_deferred("win_game")
	print(" ")

func get_current_hour():
	var ratio = time / night_duration
	var hour = int(ratio * 6)
	return clamp(hour, 0, 6)
	
	
	
func win_game():
	if !loose:
		get_tree().change_scene_to_file("res://ecran_win.tscn")
	
