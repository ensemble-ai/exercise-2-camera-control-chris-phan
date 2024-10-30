extends Node

@export var cameras: Array[CameraControllerBase]

var current_controller: int = 0


func _ready():
	for camera in cameras:
		if null != camera:
			camera.current = false

	if len(cameras) > current_controller + 1:
		_set_current_camera(current_controller)


func _process(_delta):
	if Input.is_action_just_pressed("cycle_camera_controller"):
		current_controller = (current_controller + 1) % len(cameras)
		
		for i in range(len(cameras)):
			if null != cameras[i]:
				if i == current_controller:
					_set_current_camera(current_controller)
				else:
					cameras[i].current = false
		
		# Make sure we have an active controller
		if cameras[current_controller] == null:
			for i in range(len(cameras)):
				if null != cameras[i]:
					current_controller = i
					_set_current_camera(current_controller)


# Set the current camera and make it centered on the target
func _set_current_camera(idx: int):
	cameras[idx].make_current()
	cameras[idx].global_position = cameras[idx].target.global_position
