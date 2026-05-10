extends Node

signal collectible_picked(index: int)
signal all_collected()

const TOTAL := 4
var collected       := [false, false, false, false]
var collected_count := 0
var game_over       := false
var player          : CharacterBody3D = null

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pick_collectible(index: int) -> void:
	if game_over or collected[index]:
		return
	collected[index] = true
	collected_count  += 1
	collectible_picked.emit(index)
	if collected_count >= TOTAL:
		_win()

func _win() -> void:
	game_over = true
	all_collected.emit()
	GameState.complete_minigame_and_disable_robot("jetpack", "")
	AudioManager.play_victory()
	await get_tree().create_timer(0.6).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func restart() -> void:
	game_over       = false
	collected       = [false, false, false, false]
	collected_count = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()
