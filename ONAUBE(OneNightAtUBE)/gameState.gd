extends Node
var time=0
var night_duration=500	
var win=false
var IG=false
var IGJ=false
var IGV=false
var IGC=false
var en_menu=false
var disabled_robots := {}
var completed_minigames := {}


### 1:jump
### 2:cultureG
### 3:voiture
### 4:jetpack
var activated_minigames :=[]


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
	if len(completed_minigames)==4:
		call_deferred("win_game")
	
	
	

func get_current_hour():
	var ratio = time / night_duration
	var hour = int(ratio * 6)
	return clamp(hour, 0, 6)
	
func disable_robot(robot_name: String) -> void:
	disabled_robots[robot_name] = true
	var current_scene := get_tree().current_scene
	if not current_scene:
		return
	var robot = current_scene.get_node_or_null(robot_name)
	if robot and robot.has_method("disable_robot"):
		robot.disable_robot()

func is_robot_disabled(robot_name: String) -> bool:
	return disabled_robots.get(robot_name, false)

func disable_random_active_robot() -> String:
	var current_scene := get_tree().current_scene
	if not current_scene:
		return ""

	var candidates: Array[Node] = []
	for child in current_scene.get_children():
		if child.has_method("can_be_disabled_by_minigame") and child.can_be_disabled_by_minigame():
			candidates.append(child)

	if candidates.is_empty():
		return ""

	var chosen: Node = candidates.pick_random()
	disabled_robots[chosen.name] = true
	if chosen.has_method("disable_robot"):
		chosen.disable_robot()
	return chosen.name

func is_minigame_completed(minigame_id: String) -> bool:
	return completed_minigames.get(minigame_id, false)

func complete_minigame_and_disable_robot(minigame_id: String, target_robot_name: String = "") -> String:
	if is_minigame_completed(minigame_id):
		return ""

	completed_minigames[minigame_id] = true
	if target_robot_name.strip_edges().is_empty():
		return disable_random_active_robot()
	return _disable_specific_robot_once(target_robot_name)

func _disable_specific_robot_once(robot_name: String) -> String:
	disable_robot(robot_name)
	return robot_name
	
	
func win_game():
	if !loose:
		get_tree().change_scene_to_file("res://ecran_win.tscn")
	
