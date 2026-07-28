class_name Camera_Controller
extends Node3D

# Constants
const DEFAULT_SENSITIVITY_X: float = 0.005
const DEFAULT_SENSITIVITY_Y: float = 0.005

const BASE_FOV: float = 75.0
const FOV_CHANGE: float = 0.7
const FOV_ZOOM_IN: float = 40.0

var sensitivity_x = DEFAULT_SENSITIVITY_X 
var sensitivity_y = DEFAULT_SENSITIVITY_Y

var player_controller: Player_Controller
var input_rotation: Vector3
var mouse_input := Vector2.ZERO

var use_interpolation: bool = false
var circle_strafe: bool = true

@onready var camera: Camera3D = $Camera3D
@onready var player: Player_Controller = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player_controller = get_parent()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input.x += -event.screen_relative.x * sensitivity_x
		mouse_input.y += -event.screen_relative.y * sensitivity_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_rotation.x = clampf(input_rotation.x + mouse_input.y, deg_to_rad(-90), deg_to_rad(85))
	input_rotation.y += mouse_input.x
	
	# rotate camera controller (up/down)
	player_controller.camera_controller_anchor.transform.basis = Basis.from_euler(Vector3(input_rotation.x, 0.0, 0.0))
	
	# rotate player (left/right)
	player_controller.global_transform.basis = Basis.from_euler(Vector3(0.0, input_rotation.y, 0.0))
	
	global_transform = player_controller.camera_controller_anchor.get_global_transform_interpolated()
	
	mouse_input = Vector2.ZERO
	
	# FOV system
	if Input.is_action_pressed("Zoom-In"):
		# camera.fov = FOV_ZOOM_IN
		camera.fov = lerp(camera.fov, FOV_ZOOM_IN, delta * 10.0)
	elif !Input.is_action_pressed("Backward"):
		var velocity_clamped: float = clamp(player.velocity.length(), 0.0, player.speed * 2)
		var target_fov: float = BASE_FOV + (FOV_CHANGE * velocity_clamped)
		camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	else:
		camera.fov = lerp(camera.fov, BASE_FOV, delta * 8.0)
		
	
