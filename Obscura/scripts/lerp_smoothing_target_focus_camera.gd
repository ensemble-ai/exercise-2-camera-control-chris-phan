class_name LerpSmoothingTargetFocusCamera
extends CameraControllerBase

#@export var lead_speed: float = 7.0
#@export var catchup_delay_duration: float = 0.3
#@export var catchup_speed: float = 3.0
@export var lead_speed: float = target.BASE_SPEED * 1.25
@export var catchup_delay_duration: float = 0.3
@export var catchup_speed: float = target.BASE_SPEED * 0.8

@export var leash_distance: float = 10.0

const _CROSS_WIDTH: float = 5.0
const _CROSS_HEIGHT: float = 5.0
var _unit_direction: Vector3
var _current_speed: float = lead_speed
var _lerp_to_x: float
var _lerp_to_z: float
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
	
	var tpos: Vector3 = target.global_position
	var cpos: Vector3 = global_position

	global_position.x = move_toward(cpos.x, _move_toward.x, _current_speed * delta)
	global_position.z = move_toward(cpos.z, _move_toward.z, _current_speed * delta)
	
	#var distance: float = Vector2(tpos.x - cpos.x, tpos.z - cpos.z).length()
	#print("distance: ", distance)
	#if distance > leash_distance:
		#print("leashed")
		##global_position.x = _move_toward.x
		##global_position.z = _move_toward.z
		#cpos = global_position
		#var a = (Vector3(cpos.x - tpos.x, 0, cpos.z - tpos.z)).normalized()
		#print(a)
		#global_position.x += a.x * (distance - leash_distance)
		#global_position.z += a.z * (distance - leash_distance)
	
	#var t_to_c = cpos - tpos
	#
	#print("tpos: ", tpos)
	#global_position.x = lerpf(global_position.x, _lerp_to_x, 10 * delta)
	#global_position.z = lerpf(global_position.z, _lerp_to_z, 10 * delta)
	#var distance: float = Vector2(tpos.x - cpos.x, tpos.z - cpos.z).length()
	#var t = target.velocity.normalized()
	##if target.velocity.length() > target.BASE_SPEED:
	#if distance > (leash_distance / 5) and (target.velocity.x * t_to_c.x < 0 or target.velocity.z * t_to_c.z < 0):
		#global_position.x = tpos.x + t.x * leash_distance
		#global_position.z = tpos.z + t.z * leash_distance
		#print("leashed, after: ", global_position)
		#print("distance: ", Vector2(target.global_position.x - global_position.x, target.global_position.z - global_position.z).length())
	
	#print("-------------------------")
	#print("unit_vector: ", _unit_direction)
	#print("cpos: ", cpos, " tpos: ", tpos)
	#print("_lerp_to_x: ", _lerp_to_x, " _lerp_to_z: ", _lerp_to_z)
	##global_position.x = lerpf(global_position.x, _lerp_to_x, _current_speed * delta)
	##global_position.z = lerpf(global_position.z, _lerp_to_z, _current_speed * delta)
	#print("after: global_position: ", global_position)
	#print("if leashed: x: ", tpos.x + _unit_direction.x * leash_distance, " z: ", tpos.z + _unit_direction.z * leash_distance)
	#
	#var distance: float = Vector2(tpos.x - cpos.x, tpos.z - cpos.z).length()
	#print(distance, " tpos.x: ", tpos.x, " cpos.x: ", cpos.x)
	#print("distance: ", distance, " thingy: ", (target.HYPER_SPEED * _unit_direction * delta).length(), " res: ", distance + (target.HYPER_SPEED * _unit_direction * delta).length())
	#var a = distance + (target.velocity * delta).length()
	#if (a >= leash_distance or abs(a - leash_distance) < 0.001) and _unit_direction.length() != 0:
		#print(a >= leash_distance, " or ", abs(a - leash_distance) < 0.001, " and ", _unit_direction.length() != 0)
		##print("leashed: x_inc: ", _unit_direction.x * (distance - leash_distance), " z_inc: ", _unit_direction.z * (distance - leash_distance))
		##global_position.x = tpos.x + _unit_direction.x * 11
		##global_position.z = tpos.z + _unit_direction.z * 11
	#
	##if _unit_direction.x * (cpos.x - tpos.x) < 0 or _unit_direction.z * (cpos.z - tpos.z) < 0:
		#global_position.x = tpos.x + (_unit_direction.x * leash_distance)
		#global_position.z = tpos.z + (_unit_direction.z * leash_distance)
		##global_position.x += _unit_direction.x * (distance - leash_distance)
		##global_position.z += _unit_direction.z * (distance - leash_distance)
		#print("leash")
		#print("new dist: ", (tpos - global_position).length())
		#print("new pos: ", global_position)
	#else:
		#global_position.x = lerpf(global_position.x, _lerp_to_x, _current_speed * delta)
		#global_position.z = lerpf(global_position.z, _lerp_to_z, _current_speed * delta)
	#print("-------------------------")


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
	#print("handle_stopped")
	_current_speed = 0
	
	_lerp_to_x = target.global_position.x
	_lerp_to_z = target.global_position.z
	_unit_direction = Vector3(0.0, 0.0, 0.0)
	
	var tpos: Vector3 = target.global_position
	_move_toward = Vector3(tpos.x, global_position.y, tpos.z)
	
	if _timer == null:
		_timer = Timer.new()
		add_child(_timer)
		_timer.one_shot = true
		_timer.start(catchup_delay_duration)
	elif _timer.is_stopped():
		_current_speed = catchup_speed
		_timer.stop()
		if _timer.get_parent() == self:
			remove_child(_timer)


func _handle_moved(vec: Vector3) -> void:
	_current_speed = target.velocity.length() * 1.25
	_unit_direction = vec.normalized()
	
	var tpos: Vector3 = target.global_position
	var cpos: Vector3 = global_position
	
	_lerp_to_x = tpos.x + (_unit_direction.x * leash_distance)
	_lerp_to_z = tpos.z + (_unit_direction.z * leash_distance)
	#print("_lerp_to_x: ", _lerp_to_x, " _lerp_to_z: ", _lerp_to_z)
	#print("cpos: ", cpos, " tpos: ", tpos)
	_move_toward.x = tpos.x + (_unit_direction.x * leash_distance)
	_move_toward.y = cpos.y
	_move_toward.z = tpos.z + (_unit_direction.z * leash_distance)
	
	if _timer != null:
		_timer.stop()
		if _timer.get_parent() == self:
			remove_child(_timer)
		_timer = null
