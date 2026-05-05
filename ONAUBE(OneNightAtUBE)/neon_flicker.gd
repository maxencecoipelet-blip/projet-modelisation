extends OmniLight3D

@export var base_energy := 0.45
@export var dim_energy := 0.08
@export var min_interval := 1.5
@export var max_interval := 4.0
@export var flicker_chance := 0.7
@export var burst_count_min := 1
@export var burst_count_max := 3


func _ready() -> void:
	light_energy = base_energy
	call_deferred("_flicker_loop")


func _flicker_loop() -> void:
	while true:
		await get_tree().create_timer(randf_range(min_interval, max_interval)).timeout
		if randf() > flicker_chance:
			continue

		var burst_count := randi_range(burst_count_min, burst_count_max)
		for _i in burst_count:
			light_energy = dim_energy
			await get_tree().create_timer(randf_range(0.04, 0.09)).timeout
			light_energy = base_energy
			await get_tree().create_timer(randf_range(0.05, 0.12)).timeout
