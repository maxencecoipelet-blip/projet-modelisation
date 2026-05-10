extends Node3D

@onready var win_screen : Control = $WinLayerInner/WinScreen
var _elapsed : float = 0.0
func _ready():
	for child in $bonjetpackcity.get_children():
		if child is MeshInstance3D:
			child.create_convex_collision()


func _process(delta: float) -> void:
	if not JetpackManager.game_over:
		_elapsed += delta
		if win_screen:
			win_screen.set_elapsed(_elapsed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif not JetpackManager.game_over:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
