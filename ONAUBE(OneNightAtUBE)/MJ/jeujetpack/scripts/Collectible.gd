extends Area3D

@export var collectible_index : int   = 0
@export var float_height      : float = 0.35
@export var float_speed       : float = 1.4
@export var spin_speed        : float = 1.0

const COLORS : Array[Color] = [
	Color(1.0, 0.45, 0.1, 1),
	Color(0.1, 0.75, 1.0, 1),
	Color(0.75, 0.1, 1.0, 1),
	Color(0.1, 1.0, 0.3, 1),
]

@onready var mesh_inst : MeshInstance3D = $MeshInstance3D
@onready var light     : OmniLight3D    = $OmniLight3D
@onready var particles : CPUParticles3D = $CPUParticles3D

var _origin_y  : float
var _time      : float = 0.0
var _collected : bool  = false

func _ready() -> void:
	_origin_y = global_position.y
	body_entered.connect(_on_body_entered)
	var col : Color = COLORS[collectible_index % COLORS.size()]
	if light:
		light.light_color  = col
		light.light_energy = 2.5
		light.omni_range   = 4.0
	if mesh_inst:
		var mat := StandardMaterial3D.new()
		mat.albedo_color     = col
		mat.emission_enabled = true
		mat.emission         = col
		mat.emission_energy  = 0.6
		mesh_inst.set_surface_override_material(0, mat)
	if particles:
		particles.color = col

func _process(delta: float) -> void:
	if _collected: return
	_time += delta
	global_position.y = _origin_y + sin(_time * float_speed) * float_height
	rotation.y       += spin_speed * delta
	if light:
		light.light_energy = 2.5 + sin(_time * 7.0) * 0.4

func _on_body_entered(body: Node3D) -> void:
	if _collected or not body.is_in_group("player"): return
	_collected = true
	JetpackManager.pick_collectible(collectible_index)
	$CollisionShape3D.set_deferred("disabled", true)
	if particles: particles.emitting = true
	var tw := create_tween()
	tw.tween_property(mesh_inst, "scale", Vector3.ZERO, 0.25).set_ease(Tween.EASE_IN)
	tw.tween_callback(queue_free)
	if light: light.visible = false
