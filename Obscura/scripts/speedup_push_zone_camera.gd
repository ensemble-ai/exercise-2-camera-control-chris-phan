class_name SpeedupPushZoneCamera
extends CameraControllerBase

@export var push_ratio: float = 0.75
@export var pushbox_top_left: Vector2 = Vector2(-8.0, -8.0)
@export var pushbox_bottom_right: Vector2 = Vector2(8.0, 8.0)
@export var speedup_zone_top_left: Vector2 = Vector2(-5.0, -5.0)
@export var speedup_zone_bottom_right: Vector2 = Vector2(5.0, 5.0)

var _pushbox_height: float = pushbox_bottom_right.y - pushbox_top_left.y
var _pushbox_width: float = pushbox_bottom_right.x - pushbox_top_left.x
var _speedup_height: float = speedup_zone_bottom_right.y - speedup_zone_top_left.y
var _speedup_width: float = speedup_zone_bottom_right.x - speedup_zone_top_left.x


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
	
	var tpos: Vector3 = target.global_position
	var cpos: Vector3 = global_position
	
	if target.velocity.x < 0:
		_handle_left(tpos, cpos, delta)
	if target.velocity.x > 0:
		_handle_right(tpos, cpos, delta)
	if target.velocity.z < 0:
		_handle_up(tpos, cpos, delta)
	if target.velocity.z > 0:
		_handle_down(tpos, cpos, delta)
	

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	_draw_box(speedup_zone_top_left, speedup_zone_bottom_right, immediate_mesh, Color.BLACK)
	_draw_box(pushbox_top_left, pushbox_bottom_right, immediate_mesh, Color.RED)
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()


func _handle_left(tpos: Vector3, cpos: Vector3, delta: float) -> void:
	# Handle pushbox
	var target_left_edge: float = tpos.x - (target.WIDTH / 2.0)
	var pushbox_left_edge: float = cpos.x - (_pushbox_width / 2.0)
	var diff_between_left_edges: float = target_left_edge - pushbox_left_edge
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
		return
	
	# Handle speedup zone: Apply push_ratio if the target is in a speedup zone
	# and isn't moving towards the center. If the target is in a right speedup
	# zone, then it's moving towards the center.
	var zones: Dictionary = _is_in_speedup_zones(tpos, cpos)
	if _is_in_any_speedup_zones(zones) and not zones["right"]:
		var tspeed: float = target.velocity.length()
		var target_unit_direction: Vector3 = target.velocity.normalized()
		global_position.x += target_unit_direction.x * tspeed * delta * push_ratio


func _handle_right(tpos: Vector3, cpos: Vector3, delta: float) -> void:
	# Handle pushbox
	var target_right_edge: float = tpos.x + (target.WIDTH / 2.0)
	var pushbox_right_edge: float = cpos.x + (_pushbox_width / 2.0)	
	var diff_between_right_edges: float = target_right_edge - pushbox_right_edge
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
		return
	
	# Handle speedup zone: Apply push_ratio if the target is in a speedup zone
	# and isn't moving towards the center. If the target is in a left speedup
	# zone, then it's moving towards the center.
	var zones: Dictionary = _is_in_speedup_zones(tpos, cpos)
	if _is_in_any_speedup_zones(zones) and not zones["left"]:
		var tspeed: float = target.velocity.length()
		var target_unit_direction: Vector3 = target.velocity.normalized()
		global_position.x += target_unit_direction.x * tspeed * delta * push_ratio


func _handle_up(tpos: Vector3, cpos: Vector3, delta: float) -> void:
	# Handle pushbox
	var target_top_edge: float = tpos.z - (target.HEIGHT / 2.0)
	var pushbox_top_edge: float = cpos.z - (_pushbox_height / 2.0)
	var diff_between_top_edges: float = target_top_edge - pushbox_top_edge
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
		return
	
	# Handle speedup zone: Apply push_ratio if the target is in a speedup zone
	# and isn't moving towards the center. If the target is in a bottom speedup
	# zone, then it's moving towards the center.
	var zones: Dictionary = _is_in_speedup_zones(tpos, cpos)
	if _is_in_any_speedup_zones(zones) and not zones["bottom"]:
		var tspeed: float = target.velocity.length()
		var target_unit_direction: Vector3 = target.velocity.normalized()
		global_position.z += target_unit_direction.z * tspeed * delta * push_ratio


func _handle_down(tpos: Vector3, cpos: Vector3, delta: float) -> void:
	# Handle pushbox
	var target_bot_edge: float = tpos.z + (target.HEIGHT / 2.0)
	var pushbox_bot_edge: float = cpos.z + (_pushbox_height / 2.0)
	var diff_between_bot_edges: float = target_bot_edge - pushbox_bot_edge
	if diff_between_bot_edges > 0:
		global_position.z += diff_between_bot_edges
		return
	
	# Handle speedup zone: Apply push_ratio if the target is in a speedup zone
	# and isn't moving towards the center. If the target is in a top speedup
	# zone, then it's moving towards the center.
	var zones: Dictionary = _is_in_speedup_zones(tpos, cpos)
	if _is_in_any_speedup_zones(zones) and not zones["top"]:
		var tspeed: float = target.velocity.length()
		var target_unit_direction: Vector3 = target.velocity.normalized()
		global_position.z += target_unit_direction.z * tspeed * delta * push_ratio


func _is_in_speedup_zones(tpos: Vector3, cpos: Vector3) -> Dictionary:
	var target_edges: Dictionary = _create_edges_dict(tpos, target.WIDTH, target.HEIGHT)
	var speedup_edges: Dictionary = _create_edges_dict(cpos, _speedup_width, _speedup_height)
	
	return {
		"left": target_edges["left"] < speedup_edges["left"],
		"right": target_edges["right"] > speedup_edges["right"],
		"top": target_edges["top"] < speedup_edges["top"],
		"bottom": target_edges["bottom"] > speedup_edges["bottom"],
	}


func _create_edges_dict(pos: Vector3, width: float, height: float) -> Dictionary:
	return {
		"left": pos.x - (width / 2.0),
		"right": pos.x + (width / 2.0),
		"top": pos.z - (height / 2.0),
		"bottom": pos.z + (height / 2.0),
	}


func _is_in_any_speedup_zones(zones: Dictionary) -> bool:
	return zones["left"] or zones["right"] or zones["top"] or zones["bottom"]


func _draw_box(top_left: Vector2, bot_right: Vector2, mesh: ImmediateMesh, color: Color) -> void:
	var material := ORMMaterial3D.new()
	
	var left: float = top_left.x
	var right: float = bot_right.x
	var top: float = top_left.y
	var bottom: float = bot_right.x
	
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	mesh.surface_add_vertex(Vector3(right, 0, top))
	mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	mesh.surface_add_vertex(Vector3(right, 0, bottom))
	mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	mesh.surface_add_vertex(Vector3(left, 0, bottom))
	mesh.surface_add_vertex(Vector3(left, 0, top))
	
	mesh.surface_add_vertex(Vector3(left, 0, top))
	mesh.surface_add_vertex(Vector3(right, 0, top))
	mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
