extends CharacterBody3D


const SPEED = 5.0

@export var sensitivity = 0.01 
@export var sprint_multiplier = 1.5 
var sprinting = false
var grabbed_object = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var ray := $Neck/Camera3D/RayCast3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed("sprint"):
		sprinting = true
	elif event.is_action_pressed("use"):
		if grabbed_object != null: # if we are holding an object and click, set it down
			grabbed_object = null
		else:
			ray.force_raycast_update()
			if ray.is_colliding():
				var collider = ray.get_collider()
				if collider.has_method("_use"):
					collider._use()
				elif collider.has_method("_grab"):
					grabbed_object = collider
				
	if grabbed_object != null:
		print("holding")
		
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * sensitivity)
			camera.rotate_x(-event.relative.y * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	if sprinting && input_dir.y >= 0:
		sprinting = false
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if direction:
		velocity.x = direction.x * GetCurrentSpeed()
		velocity.z = direction.z * GetCurrentSpeed()
	else:
		velocity.x = move_toward(velocity.x, 0, GetCurrentSpeed())
		velocity.z = move_toward(velocity.z, 0, GetCurrentSpeed())
	move_and_slide()

func GetCurrentSpeed():
	if sprinting:
		return SPEED * sprint_multiplier
	else:
		return SPEED
