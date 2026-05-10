extends SubViewportContainer

@export var scene: PackedScene
var mini_game_instance = null

func open_minigame():
	if mini_game_instance == null:
		mini_game_instance = scene.instantiate()
		$SubViewport.add_child(mini_game_instance)

	_activate_only_this()
	
	


func _activate_only_this():

	for child in mini_game_instance.get_children():
		if child.has_method("set_active"):
			child.set_active(true)
			print("test")
	
	# Active la caméra
	var cam = _find_first_camera(mini_game_instance)
	if cam:
		cam.current = true

func _find_first_camera(node: Node) -> Camera3D:
	if node is Camera3D:
		return node

	for child in node.get_children():
		var cam = _find_first_camera(child)
		if cam:
			return cam

	return null
