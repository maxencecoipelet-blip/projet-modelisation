extends Node3D
@onready var tel=$telephone
@onready var tel2=$telephone2
@onready var label=$telephone/CanvasLayer/Label
var first_time=true

func _enter_tree() -> void:
	_reset_game_state()

func _ready() -> void:
	AudioManager.start_game_music()
	tel2.play()

func _reset_game_state() -> void:
	GameState.time = 0
	GameState.IG = false
	GameState.loose = false
	GameState.win = false
	GameState.on_pc = false
	GameState.en_menu = false
	GameState.disabled_robots.clear()
	GameState.completed_minigames.clear()
	GameState.activated_minigames.clear()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and first_time:
		first_time=false
		tel2.stop()
		tel.play()
		label.visible=true
		
		
	
	


func _on_area_3d_body_exited(body: Node3D) -> void:
	label.visible=false


func _on_sous_la_map_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameState.loose = true
		AudioManager.notify_robot_stopped_chase()
		get_tree().change_scene_to_file("res://ecran_mort.tscn")
