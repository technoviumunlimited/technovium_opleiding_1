extends CharacterBody3D

@onready var head = $head
@onready var ray_cast_3d = $head/Camera3D/RayCast3D
@onready var label = $Control/Label
@onready var lift_cabine = $"../elevator/lift_cabine"
@onready var _0_floor_door_left = $"../lift/0_floor_door_left"
@onready var player = $"."

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.4
const RUN_SPEED = 10.0 
const MAX_JUMPS = 2

var is_running = false 
var jump_count = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var elevator_position : float = 0.00

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	elif event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
			head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-30), deg_to_rad(60))
	if Input.is_action_pressed("sprint"):
		is_running = true
	else:
		is_running = false		

func _ready():
	$crosshair.show()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		jump_count = 0  # Reset jump counter when on the ground
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var current_speed = RUN_SPEED if is_running else SPEED 
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	var target = ray_cast_3d.get_collider()
	label.hide()
	var open_0_floor_door :bool = false
	if target != null:
		if target.is_in_group("0_floor_call_lift"):
			var _0_floor_left_door = create_tween()
			if open_0_floor_door == false:
				_0_floor_left_door.tween_property(_0_floor_door_left, "rotation_degrees:y", -0.8, 1.0)
				open_0_floor_door = true
		# raycast education
		if target.is_in_group("education_choise"):
			label.show()
			label.text = "Ontdek " + target.name + "!"
			if Input.is_action_just_pressed("left_mouse_click"):
				if target.name == "Technicus Engineering – Elektrotechniek":
					elevator_position = 4.29
				if target.name == "Technicus Engineering – Werktuigbouwkunde Energietechniek":
					elevator_position = 4.29
				if target.name == "Software developer":
					elevator_position = 9.1
				if target.name == "Mediavormgever":
					elevator_position = 13.49
				if target.name == "Expert IT systems and devices":
					elevator_position = 9.1
				#print("interact")
				#get_tree().paused = true
				#get_tree().change_scene_to_file("res://elektrotechniek.tscn")
				var _elektrotechniek = create_tween()
				_elektrotechniek.tween_property(lift_cabine, "position:y", elevator_position, 1.0)
	#if Input.is_action_pressed("shoot"):
		#shoot()
	move_and_slide()

func shoot():
	if ray_cast_3d.is_colliding():
		var colpoint = ray_cast_3d.get_collision_point()
		var normal = ray_cast_3d.get_collision_normal()
		var target = ray_cast_3d.get_collider()
		if target != null:
			if target.is_in_group("lift_panel") && target.has_method("witch_floor"):
				target.witch_floor(2)
	
