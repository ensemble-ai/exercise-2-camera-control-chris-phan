class_name AutoScrollCamera
extends CameraControllerBase

@export var top_left: Vector2
@export var bottom_right: Vector2
@export var autoscroll_speed: Vector3


func _ready() -> void:
	super()
	position = target.position


func _process(delta: float) -> void:
	if !current:
		return

	if draw_camera_logic:
		draw_logic()
	
	super(delta)


func _physics_process(delta: float) -> void:
	if !current:
		return
	
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta
	
	# Uncomment for target to move relative to the camera
	# i.e. if the target doesn't move, it will stay in the same position on the screen
	target.global_position.x += autoscroll_speed.x * delta
	target.global_position.z += autoscroll_speed.z * delta
	
	# Prevent target from getting outside of the camera
	var tpos: Vector3 = target.global_position
	var cpos: Vector3 = global_position
	var box_width: float = bottom_right.x - top_left.x
	var box_height: float = bottom_right.y - top_left.y
	
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	if diff_between_left_edges < 0:
		target.global_position.x = global_position.x - (box_width / 2.0) + (target.WIDTH / 2.0)
	
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	if diff_between_right_edges > 0:
		target.global_position.x = global_position.x + (box_width / 2.0) - (target.WIDTH / 2.0)
	
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	if diff_between_top_edges < 0:
		target.global_position.z = global_position.z - (box_height / 2.0) + (target.HEIGHT / 2.0)
	
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	if diff_between_bottom_edges > 0:
		target.global_position.z = global_position.z + (box_height / 2.0) - (target.HEIGHT / 2.0)


func draw_logic() ->  void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var box_width: float = bottom_right.x - top_left.x
	var box_height: float = bottom_right.y - top_left.y
	
	var left:float = -box_width / 2
	var right:float = box_width / 2
	var top:float = -box_height / 2
	var bottom:float = box_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
