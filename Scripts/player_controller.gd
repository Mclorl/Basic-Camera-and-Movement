class_name Player_Controller
extends CharacterBody3D

# Constants
const WALK_SPEED: float = 2.0
const SPRINT_SPEED: float = 4.0
const JUMP_VELOCITY: float = 3.5

var speed = WALK_SPEED

@onready var camera_controller_anchor: Marker3D = $Camera_Controller_Anchor


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	# Sprint speed
	speed = SPRINT_SPEED if Input.is_action_pressed("Shift") else WALK_SPEED
	
	var input_dir: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	
	var new_velocity = Vector2.ZERO
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			new_velocity = Vector2(direction.x, direction.z) * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 9.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 9.0)
		velocity = Vector3(new_velocity.x, velocity.y, new_velocity.y)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	move_and_slide()
	
	# Note:
	# - turn on physics interpolation.
	# - set the physics jitter fix to 0.
