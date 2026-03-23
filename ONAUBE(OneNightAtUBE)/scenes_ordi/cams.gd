extends TextureRect

@onready var viewport = get_node("../../../../cam1/SubViewport")
@onready var viewport2 = get_node("../../../../cam2/SubViewport")
var compteur=0
var total=2

func _ready():
	
	texture = viewport.get_texture()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		compteur+=1
		next()
	
func next():
	if compteur%total==0:
		texture=viewport.get_texture()
	elif compteur%total==1 :
		texture=viewport2.get_texture()
	
