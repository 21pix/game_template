extends Node

@onready var camera_3d_2: Camera3D = $Camera3D2
@onready var camera_3d_3: Camera3D = $Camera3D3
@onready var camera_3d_1: Camera3D = $Camera3D
@onready var active_cam = Camera3D

var input_mouse: Vector2
var rotation_target: Vector3
@export var mouse_sensitivity = 700

func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("map_cam_1"):
		active_cam = camera_3d_1
		active_cam.current = true
	
	if Input.is_action_pressed("map_cam_2"):
		active_cam = camera_3d_2
		active_cam.current = true

		
	if Input.is_action_pressed("map_cam_3"):
		active_cam = camera_3d_3
		active_cam.current = true
	cam_move(delta)
		
func cam_move(delta):
	camera_3d_1.rotation.z = lerp_angle(camera_3d_1.rotation.z, -input_mouse.x * 5 * delta, delta * 30)	# 5 is cam tilt factor
	camera_3d_1.rotation.x = lerp_angle(camera_3d_1.rotation.x, rotation_target.x, delta * 25)
	camera_3d_1.rotation.y = lerp_angle(camera_3d_1.rotation.y, rotation_target.y, delta * 25)
	
	camera_3d_2.rotation.z = lerp_angle(camera_3d_2.rotation.z, -input_mouse.x * 5 * delta, delta * 30)	# 5 is cam tilt factor
	camera_3d_2.rotation.x = lerp_angle(camera_3d_2.rotation.x, rotation_target.x, delta * 25)
	camera_3d_2.rotation.y = lerp_angle(camera_3d_2.rotation.y, rotation_target.y, delta * 25)	
	
	camera_3d_3.rotation.z = lerp_angle(camera_3d_3.rotation.z, -input_mouse.x * 5 * delta, delta * 30)	# 5 is cam tilt factor
	camera_3d_3.rotation.x = lerp_angle(camera_3d_3.rotation.x, rotation_target.x, delta * 25)
	camera_3d_3.rotation.y = lerp_angle(camera_3d_3.rotation.y, rotation_target.y, delta * 25)	
	
	rotation_target.x = clamp(rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
# Mouse movement

func _input(event):
	if event is InputEventMouseMotion:
		
		input_mouse = event.relative / mouse_sensitivity
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity
