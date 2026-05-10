extends Node3D
var player

@export var id_MJ = 0
@onready var minijeu = $MJ
@onready var subMJ = $MJ/SubViewportContainer
@onready var laptop_screen = get_node_or_null("laptop/Laptop/Laptop_Screen")

func _ready() -> void:
	print("SCRIPT SUR :", get_path())
	print("laptop_screen =", laptop_screen)
	update_visual()

func update_visual():
	if not laptop_screen:
		print("Laptop_Screen introuvable")
		return

	if id_MJ in GameState.activated_minigames:
		laptop_screen.set_surface_override_material(2, null)

func _process(delta: float) -> void:
	update_visual()
	if Input.is_action_just_pressed("pause") and GameState.on_pc and player:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		GameState.on_pc = false
		minijeu.visible = false
		GameState.IGV = false
		GameState.IGJ = false
		GameState.IGC = false
		GameState.IGV = false
		
		
		
	elif player and Input.is_action_just_pressed("interagir"):
		interact()

func interact():
	if id_MJ in GameState.activated_minigames:
		GameState.on_pc = true
		match id_MJ	:
			2:
				GameState.IGC=true
			3:
				GameState.IGV=true
			4:
				GameState.IGJ=true
				
				
		call_deferred("open_computer")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if id_MJ in GameState.activated_minigames:
			player = body
		else:
			print("MJ non disponible")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null
		GameState.on_pc = false

func open_computer():
	minijeu.visible = true
	subMJ.open_minigame()
