extends Node



var chasing_robots := 0
var ambience_base_volume := -35.0
var ambience_chase_volume := -45.0
var chase_base_volume := 0.0
var menu_base_volume := 0.0
var ventilo_base_volume := -22.0
var ventilo_chase_volume := -28.0
var fade_duration := 1.2
var room_ambience_fade_duration := 0.35
var random_ambience_delay_min := 5.0
var random_ambience_delay_max := 30
var volume_tween: Tween
var room_ambience_tween: Tween
var room_ambience_enabled := false
var random_ambience_loop_started := false
var random_ambience_players: Array[AudioStreamPlayer] = []


@onready var musique_ambiance = $MusiqueAmbiance
@onready var musique_chasse = $MusiqueChasse
@onready var clic_menu = $ClicMenu
@onready var game_over = $GameOver
@onready var musique_menu = $MusiqueMenu
@onready var son_chasse = $SonChasse
@onready var victoire = get_node_or_null("Victoire")
@onready var ventilo = get_node_or_null("Ventilo")
@onready var buzz_electrique = get_node_or_null("BuzzElectrique")
@onready var craquement_electrique = get_node_or_null("CraquementElectrique")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	randomize()
	_collect_random_ambience_players()
	ambience_base_volume = musique_ambiance.volume_db
	chase_base_volume = musique_chasse.volume_db
	menu_base_volume = musique_menu.volume_db
	if ventilo:
		ventilo_base_volume = ventilo.volume_db
		ventilo.volume_db = ventilo_base_volume - 8.0
	musique_chasse.volume_db = -80.0
	_ensure_random_ambience_loop()
	play_menu_music()

func play_menu_music() -> void:
	chasing_robots = 0
	room_ambience_enabled = false
	_stop_volume_tween()
	_stop_room_ambience_tween()
	if musique_ambiance.playing:
		musique_ambiance.stop()
	if musique_chasse.playing:
		musique_chasse.stop()
	_stop_room_ambience()
	musique_ambiance.volume_db = ambience_base_volume
	musique_chasse.volume_db = -80.0
	musique_menu.volume_db = menu_base_volume
	if not musique_menu.playing:
		musique_menu.play()

func start_game_music() -> void:
	chasing_robots = 0
	room_ambience_enabled = true
	_stop_volume_tween()
	if musique_menu.playing:
		musique_menu.stop()
	musique_chasse.stop()
	musique_chasse.volume_db = -80.0
	play_ambience()
	_start_room_ambience()

func play_ambience() -> void:
	if musique_menu.playing:
		musique_menu.stop()
	if not musique_ambiance.playing:
		musique_ambiance.play()
	musique_ambiance.volume_db = ambience_base_volume

func notify_robot_started_chase() -> void:
	chasing_robots += 1
	if chasing_robots == 1:
		if not musique_chasse.playing:
			musique_chasse.play()
		if not son_chasse.playing:
			son_chasse.play()
		_fade_for_chase_start()
		_reduce_room_ambience_for_chase()


func notify_robot_stopped_chase() -> void:
	chasing_robots = max(chasing_robots - 1, 0)
	if chasing_robots == 0:
		if son_chasse.playing:
			son_chasse.stop()
		_fade_for_chase_stop()
		_restore_room_ambience_after_chase()


func play_ui_click() -> void:
	clic_menu.play()

func play_game_over() -> void:
	stop_all_music()
	game_over.stop()
	game_over.play()

func play_victory() -> void:
	stop_all_music()
	if victoire:
		victoire.stop()
		victoire.play()

func stop_all_music() -> void:
	chasing_robots = 0
	room_ambience_enabled = false
	_stop_volume_tween()
	_stop_room_ambience_tween()
	musique_ambiance.stop()
	musique_chasse.stop()
	musique_menu.stop()
	game_over.stop()
	son_chasse.stop()
	_stop_room_ambience()

	if victoire:
		victoire.stop()

func _fade_for_chase_start() -> void:
	_stop_volume_tween()
	volume_tween = create_tween()
	volume_tween.set_parallel(true)
	volume_tween.tween_property(musique_ambiance, "volume_db", ambience_chase_volume, fade_duration)
	volume_tween.tween_property(musique_chasse, "volume_db", chase_base_volume, fade_duration)

func _fade_for_chase_stop() -> void:
	_stop_volume_tween()
	volume_tween = create_tween()
	volume_tween.set_parallel(true)
	volume_tween.tween_property(musique_ambiance, "volume_db", ambience_base_volume, fade_duration)
	volume_tween.tween_property(musique_chasse, "volume_db", -80.0, fade_duration)
	volume_tween.finished.connect(_stop_chase_if_idle)

func _stop_chase_if_idle() -> void:
	if chasing_robots == 0:
		musique_chasse.stop()

func _stop_volume_tween() -> void:
	if volume_tween and volume_tween.is_valid():
		volume_tween.kill()

func _ensure_random_ambience_loop() -> void:
	if random_ambience_loop_started:
		return
	random_ambience_loop_started = true
	call_deferred("_random_ambience_loop")

func _random_ambience_loop() -> void:
	while is_inside_tree():
		await get_tree().create_timer(randf_range(random_ambience_delay_min, random_ambience_delay_max)).timeout
		if room_ambience_enabled and chasing_robots == 0:
			_play_random_ambience_event()

func _play_random_ambience_event() -> void:
	var available_players: Array[AudioStreamPlayer] = []
	for player in random_ambience_players:
		if player and player.stream and not player.playing:
			available_players.append(player)

	if available_players.is_empty():
		return

	available_players.pick_random().play()

func _start_room_ambience() -> void:
	if ventilo and ventilo.stream:
		if not ventilo.playing:
			ventilo.play()
		_stop_room_ambience_tween()
		ventilo.volume_db = ventilo_base_volume - 8.0
		room_ambience_tween = create_tween()
		room_ambience_tween.tween_property(ventilo, "volume_db", ventilo_base_volume, room_ambience_fade_duration)

func _stop_room_ambience() -> void:
	if ventilo and ventilo.playing:
		ventilo.stop()
	for player in random_ambience_players:
		if player and player.playing:
			player.stop()

func _reduce_room_ambience_for_chase() -> void:
	if ventilo and ventilo.playing:
		_stop_room_ambience_tween()
		room_ambience_tween = create_tween()
		room_ambience_tween.tween_property(ventilo, "volume_db", ventilo_chase_volume, 0.8)

func _restore_room_ambience_after_chase() -> void:
	if room_ambience_enabled and ventilo and ventilo.playing:
		_stop_room_ambience_tween()
		room_ambience_tween = create_tween()
		room_ambience_tween.tween_property(ventilo, "volume_db", ventilo_base_volume, 1.0)

func _stop_room_ambience_tween() -> void:
	if room_ambience_tween and room_ambience_tween.is_valid():
		room_ambience_tween.kill()

func _collect_random_ambience_players() -> void:
	random_ambience_players.clear()
	for child in get_children():
		if child is AudioStreamPlayer and (child.name == "BuzzElectrique" or child.name == "CraquementElectrique" or child.name.begins_with("AmbienceEvent")):
			random_ambience_players.append(child)
