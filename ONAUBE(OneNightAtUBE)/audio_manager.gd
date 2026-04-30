extends Node

var chasing_robots := 0
var ambience_base_volume := -35.0
var ambience_chase_volume := -45.0

@onready var musique_ambiance = $MusiqueAmbiance
@onready var musique_chasse = $MusiqueChasse
@onready var clic_menu = $ClicMenu
@onready var game_over = $GameOver

func _ready() -> void:
	ambience_base_volume = musique_ambiance.volume_db
	play_ambience()

func play_ambience() -> void:
	if not musique_ambiance.playing:
		musique_ambiance.play()
	musique_ambiance.volume_db = ambience_base_volume

func notify_robot_started_chase() -> void:
	chasing_robots += 1
	if chasing_robots == 1:
		musique_ambiance.volume_db = ambience_chase_volume
		if not musique_chasse.playing:
			musique_chasse.play()

func notify_robot_stopped_chase() -> void:
	chasing_robots = max(chasing_robots - 1, 0)
	if chasing_robots == 0:
		musique_chasse.stop()
		musique_ambiance.volume_db = ambience_base_volume

func play_ui_click() -> void:
	clic_menu.play()

func play_game_over() -> void:
	game_over.play()
