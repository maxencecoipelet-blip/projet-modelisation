extends Control

var _time_label    : Label
var _elapsed       : float = 0.0
var _replay_button : Button
var _quit_button   : Button

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	visible = false
	_build_ui()
	JetpackManager.all_collected.connect(_show)

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 0.75)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var panel := PanelContainer.new()
	panel.set_anchor(SIDE_LEFT,   0.5)
	panel.set_anchor(SIDE_RIGHT,  0.5)
	panel.set_anchor(SIDE_TOP,    0.5)
	panel.set_anchor(SIDE_BOTTOM, 0.5)
	panel.set_offset(SIDE_LEFT,  -280)
	panel.set_offset(SIDE_RIGHT,  280)
	panel.set_offset(SIDE_TOP,   -220)
	panel.set_offset(SIDE_BOTTOM, 220)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.12, 0.97)
	style.border_color = Color(0.4, 0.8, 1.0, 0.9)
	style.border_width_left   = 3
	style.border_width_right  = 3
	style.border_width_top    = 3
	style.border_width_bottom = 3
	style.corner_radius_top_left     = 16
	style.corner_radius_top_right    = 16
	style.corner_radius_bottom_left  = 16
	style.corner_radius_bottom_right = 16
	style.content_margin_left   = 40
	style.content_margin_right  = 40
	style.content_margin_top    = 40
	style.content_margin_bottom = 40
	panel.add_theme_stylebox_override("panel", style)
	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	panel.add_child(vbox)
	var title := Label.new()
	title.text = "🎉  BRAVO !"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.1))
	vbox.add_child(title)
	var sub := Label.new()
	sub.text = "Tu as récupéré les 4 objets !"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 24)
	sub.add_theme_color_override("font_color", Color(0.85, 0.85, 0.95))
	vbox.add_child(sub)
	vbox.add_child(HSeparator.new())
	_time_label = Label.new()
	_time_label.text = "Temps : —"
	_time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_time_label.add_theme_font_size_override("font_size", 28)
	_time_label.add_theme_color_override("font_color", Color(0.5, 0.9, 1.0))
	vbox.add_child(_time_label)
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 24)
	vbox.add_child(hbox)
	_replay_button = Button.new()
	_replay_button.text = "🔄  Rejouer"
	_replay_button.custom_minimum_size = Vector2(180, 56)
	_replay_button.add_theme_font_size_override("font_size", 20)
	_replay_button.pressed.connect(_on_replay)
	hbox.add_child(_replay_button)
	_quit_button = Button.new()
	_quit_button.text = "❌  Quitter"
	_quit_button.custom_minimum_size = Vector2(180, 56)
	_quit_button.add_theme_font_size_override("font_size", 20)
	_quit_button.pressed.connect(_on_quit)
	hbox.add_child(_quit_button)
	add_child(panel)

func _show() -> void:
	visible = true
	modulate = Color(1, 1, 1, 0)
	var min_v := int(_elapsed / 60.0)
	var sec := int(fmod(_elapsed, 60.0))
	_time_label.text = "Temps : %d:%02d" % [min_v, sec]
	var tw := create_tween()
	tw.tween_property(self, "modulate", Color.WHITE, 0.7).set_ease(Tween.EASE_OUT)

func set_elapsed(t: float) -> void:
	_elapsed = t

func _on_replay() -> void:
	JetpackManager.restart()

func _on_quit() -> void:
	get_tree().quit()
