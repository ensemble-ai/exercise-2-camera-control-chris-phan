class_name LerpSmoothingTargetFocusCamera
extends CameraControllerBase

@export var lead_speed: float = target.BASE_SPEED * 1.25
@export var catchup_delay_duration: float = 0.3
@export var catchup_speed: float = target.BASE_SPEED * 0.8
@export var leash_distance: float = 10.0

const _CROSS_WIDTH: float = 5.0
const _CROSS_HEIGHT: float = 5.0
var _unit_direction: Vector3
var _current_speed: float = lead_speed
var _move_toward: Vector3
@onready var _timer: Timer


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
	
	var cpos: Vector3 = global_position
	
	global_position.x = move_toward(cpos.x, _move_toward.x, _current_speed * delta)
	global_position.z = move_toward(cpos.z, _move_toward.z, _current_speed * delta)


func draw_logic() -> void:
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
	_current_speed = 0
	_unit_direction = Vector3(0.0, 0.0, 0.0)
	
	# Move the camera towards the target
	var tpos: Vector3 = target.global_position
	_move_toward = Vector3(tpos.x, global_position.y, tpos.z)
	
	if _timer == null:
		# Create and start a timer
		_timer = Timer.new()
		add_child(_timer)
		_timer.one_shot = true
		_timer.start(catchup_delay_duration)
	elif _timer.is_stopped():
		# Set the speed of the camera to be non-zero
		_current_speed = catchup_speed
		if _timer.get_parent() == self:
			remove_child(_timer)


func _handle_moved(input_vector: Vector3) -> void:
	_current_speed = target.velocity.length() * 1.25
	_unit_direction = input_vector.normalized()
	
	var tpos: Vector3 = target.global_position
	var cpos: Vector3 = global_position
	
	# The camera moves towards the point that is leash_distance away from the
	# target and in the direction that the target is currently moving
	_move_toward.x = tpos.x + (_unit_direction.x * leash_distance)
	_move_toward.y = cpos.y
	_move_toward.z = tpos.z + (_unit_direction.z * leash_distance)
	
	if _timer != null:
		# Ignore the timer if there was one running; prioritize moving
		# the camera forward rather than moving it back to the target
		_timer.stop()
		if _timer.get_parent() == self:
			remove_child(_timer)
		_timer = null
