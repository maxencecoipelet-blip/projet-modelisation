extends SubViewportContainer

var mini_game_instance = null

func open_minigame():
	# Instancier une seule fois
	if mini_game_instance == null:
		mini_game_instance = preload("res://MJ/mini_jeu.tscn").instantiate()
		
		# Active la caméra du mini-jeu si elle existe
		var cam = mini_game_instance.get_node_or_null("Camera3D")
		if cam:
			cam.current = true
		# Ajouter le mini-jeu au viewport
		$SubViewport.add_child(mini_game_instance)
	
	visible = true  # rend le panel visible
