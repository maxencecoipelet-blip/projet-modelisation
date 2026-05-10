extends Control

const COLORS : Array[Color] = [
	Color(1.0, 0.45, 0.1),
	Color(0.1, 0.75, 1.0),
	Color(0.75, 0.1, 1.0),
	Color(0.1, 1.0, 0.3),
]
const LABELS : Array[String] = ["🔶", "🔷", "🟣", "🟢"]

var _slots    : Array[Control] = []
var _checks   : Array[Label]   = []
var _fuel_bar : ProgressBar
var _player   : CharacterBody3D = null

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_collectibles_panel()
	_build_fuel_bar()
	JetpackManager.collectible_picked.connect(_on_picked)
	JetpackManager.all_collected.connect(_on_win)

func _process(_delta: float) -> void:
	if not _player:
		_player = JetpackManager.player
	if _player and is_instance_valid(_player):
		_fuel_bar.value = _player.get_fuel_ratio() * 100.0

func _build_collectibles_panel() -> void:
	var panel := PanelContainer.new()
	panel.set_anchor(SIDE_LEFT,   1.0)
	panel.set_anchor(SIDE_RIGHT,  1.0)
	panel.set_anchor(SIDE_TOP,    0.0)
	panel.set_anchor(SIDE_BOTTOM, 0.0)
	panel.set_offset(SIDE_LEFT,  -360)
	panel.set_offset(SIDE_RIGHT, -16)
	panel.set_offset(SIDE_TOP,    16)
	panel.set_offset(SIDE_BOTTOM, 110)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.5)
	style.corner_radius_top_left     = 8
	style.corner_radius_top_right    = 8
	style.corner_radius_bottom_left  = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left   = 8
	style.content_margin_right  = 8
	style.content_margin_top    = 8
	style.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", style)
	var vbox := VBoxContainer.new()
	panel.add_child(vbox)
	var title := Label.new()
	title.text = "OBJECTIFS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color.WHITE)
	title.add_theme_font_size_override("font_size", 13)
	vbox.add_child(title)
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 10)
	vbox.add_child(hbox)
	for i in range(4):
		var slot := _make_slot(i)
		hbox.add_child(slot)
		_slots.append(slot)
	add_child(panel)

func _make_slot(index: int) -> Control:
	var container := Control.new()
	container.custom_minimum_size = Vector2(64, 64)
	var bg := ColorRect.new()
	bg.color = Color(COLORS[index].r, COLORS[index].g, COLORS[index].b, 0.3)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	container.add_child(bg)
	var icon := Label.new()
	icon.text = LABELS[index]
	icon.add_theme_font_size_override("font_size", 28)
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	container.add_child(icon)
	var check := Label.new()
	check.text = "✓"
	check.add_theme_font_size_override("font_size", 38)
	check.add_theme_color_override("font_color", Color.WHITE)
	check.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	check.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	check.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	check.visible = false
	container.add_child(check)
	_checks.append(check)
	return container

func _build_fuel_bar() -> void:
	var panel := PanelContainer.new()
	panel.set_anchor(SIDE_LEFT,   0.0)
	panel.set_anchor(SIDE_RIGHT,  0.0)
	panel.set_anchor(SIDE_TOP,    1.0)
	panel.set_anchor(SIDE_BOTTOM, 1.0)
	panel.set_offset(SIDE_LEFT,   16)
	panel.set_offset(SIDE_RIGHT,  220)
	panel.set_offset(SIDE_TOP,   -80)
	panel.set_offset(SIDE_BOTTOM, -16)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.5)
	style.corner_radius_top_left     = 8
	style.corner_radius_top_right    = 8
	style.corner_radius_bottom_left  = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left   = 10
	style.content_margin_right  = 10
	style.content_margin_top    = 8
	style.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", style)
	var vbox := VBoxContainer.new()
	panel.add_child(vbox)
	var lbl := Label.new()
	lbl.text = "⛽  JETPACK"
	lbl.add_theme_color_override("font_color", Color(1, 0.6, 0.2))
	lbl.add_theme_font_size_override("font_size", 14)
	vbox.add_child(lbl)
	_fuel_bar = ProgressBar.new()
	_fuel_bar.max_value           = 100
	_fuel_bar.value               = 100
	_fuel_bar.show_percentage     = false
	_fuel_bar.custom_minimum_size = Vector2(180, 18)
	vbox.add_child(_fuel_bar)
	add_child(panel)

func _on_picked(index: int) -> void:
	if index >= _slots.size(): return
	_checks[index].visible = true
	var tw := create_tween()
	tw.tween_property(_slots[index], "scale", Vector2(1.25, 1.25), 0.1)
	tw.tween_property(_slots[index], "scale", Vector2(1.0,  1.0),  0.15)
	var bg : ColorRect = _slots[index].get_child(0)
	var tw2 := create_tween()
	tw2.tween_property(bg, "color", Color(COLORS[index].r, COLORS[index].g, COLORS[index].b, 0.05), 0.4)

func _on_win() -> void:
	var tw := create_tween()
	tw.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.6)
