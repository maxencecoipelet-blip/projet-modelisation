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
	var cam = mini_game_instance.get_node_or_null("Camera3D")
	if cam:
		cam.current = true
