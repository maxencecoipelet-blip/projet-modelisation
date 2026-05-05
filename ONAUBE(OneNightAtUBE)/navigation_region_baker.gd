extends NavigationRegion3D

@export var bake_on_ready := true
@export var source_geometry_root_path: NodePath = NodePath("../projet")


func _ready() -> void:
	if bake_on_ready:
		call_deferred("_bake_navigation_mesh_now")


func _bake_navigation_mesh_now() -> void:
	if navigation_mesh == null:
		return

	var source_root := get_node_or_null(source_geometry_root_path) as Node3D
	if source_root == null:
		return

	var previous_parent := source_root.get_parent()
	var previous_global_transform := source_root.global_transform

	if previous_parent != self:
		previous_parent.remove_child(source_root)
		add_child(source_root)
		source_root.global_transform = previous_global_transform

	bake_navigation_mesh(false)

	if previous_parent != self:
		remove_child(source_root)
		previous_parent.add_child(source_root)
		source_root.global_transform = previous_global_transform
