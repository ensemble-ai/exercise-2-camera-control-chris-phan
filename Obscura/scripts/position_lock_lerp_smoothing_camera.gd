class_name PositionLockLerpSmoothingCamera
extends CameraControllerBase

# follow_speed and catcup_speed aren't in the same units as the target's speed
# since they're used for the lerp function which requires a weight between 0 and 1
@export var follow_speed: float = 3.0
@export var catchup_speed: float = 7.0
@export var leash_distance: float = 10.0

const _CROSS_WIDTH: float = 5.0
const _CROSS_HEIGHT: float = 5.0

var _current_speed: float = follow_speed


func _ready() -> void:
	super()
	position = target.position
	SignalBus.vessel_stopped.connect(_handle_stopped_moving)
	SignalBus.vessel_moved.connect(_handle_moved)


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	super(delta)


func _physics_process(delta: float) -> void:
	if !current:
		return
	
	var tpos: Vector3 = target.global_position
	var cpos: Vector3 = global_position
	
	# Move towards the target's position
	global_position.x = lerpf(cpos.x, tpos.x, _current_speed * delta)
	global_position.z = lerpf(cpos.z, tpos.z, _current_speed * delta)
	
	var distance: float = Vector2(tpos.x - cpos.x, tpos.z - cpos.z).length()
	if distance > leash_distance:
		# Set the camera's position to be leash distance away from the target
		# and in the opposite direction from the target's movement.
		# In other words, the camera turns into a pushbox
		var unit_direction: Vector3 = (tpos - cpos).normalized()
		global_position.x += unit_direction.x * (distance - leash_distance)
		global_position.z += unit_direction.z * (distance - leash_distance)


func draw_logic() ->  void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left: float = -_CROSS_WIDTH / 2
	var right: float = _CROSS_WIDTH / 2
	var top: float = -_CROSS_HEIGHT / 2
	var bottom: float = _CROSS_HEIGHT / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()


func _handle_stopped_moving() -> void:
	_current_speed = catchup_speed


func _handle_moved(_vec: Vector3) -> void:
	_current_speed = follow_speed
