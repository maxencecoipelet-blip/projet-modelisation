extends Node3D

func _enter_tree() -> void:
	_reset_game_state()

func _ready() -> void:
	AudioManager.start_game_music()

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
