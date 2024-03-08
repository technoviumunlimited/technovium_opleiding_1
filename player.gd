extends CharacterBody3D

@onready var head = $head
@onready var ray_cast_3d = $head/Camera3D/RayCast3D
@onready var label = $Control/Label
@onready var lift_cabine = $"../elevator/lift_cabine"
@onready var player = $"."
@onready var success = $"../technovium/audio/success"

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.4
const RUN_SPEED = 10.0 
const MAX_JUMPS = 2

var is_running = false 
var jump_count = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var elevator_position : float = 0.00
@onready var lift_timer = $"../elevator/lift_cabine/lift_timer"
@onready var teleporter_place = $"../Bijgebouw/teleporter_place"


var _cabine_position

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
	lift_timer.start()
	

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
	if target != null:
		print(target.name)
		if target.is_in_group("teleporter"):
			if target.name == "teleportertimmeren":
				player.global_position = teleporter_place.global_transform.origin
				
		
		# raycast education
		if target.is_in_group("education_choise"):
			label.show()
			label.text = target.name + "!"
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
					elevator_position = 9.05
				if target.name == "Schilder":
					elevator_position = 9.065
				if target.name == "Timmeren":
					elevator_position = 9.065
					success.play()
				if target.name == "Begane grond":
					elevator_position = 0
				_cabine_position_function(lift_cabine, elevator_position)
				
	#if Input.is_action_pressed("shoot"):
		#shoot()
		if target.is_in_group("photoUrl"):
			label.show()
			label.text = "Check onze website"
			if Input.is_action_just_pressed("left_mouse_click"):
				OS.shell_open("https://www.roc-nijmegen.nl/mbo-opleidingen/bouw-en-afbouw/timmeren-schilderen/gezel-schilder-01455o")
					
	move_and_slide()

func shoot():
	if ray_cast_3d.is_colliding():
		var colpoint = ray_cast_3d.get_collision_point()
		var normal = ray_cast_3d.get_collision_normal()
		var target = ray_cast_3d.get_collider()
		if target != null:
			if target.is_in_group("lift_panel") && target.has_method("witch_floor"):
				target.witch_floor(2)
	

func _cabine_position_function(lift_cabine, elevator_position):
	_cabine_position = create_tween()
	_cabine_position.tween_property(lift_cabine, "position:y", elevator_position, 2.0).set_trans(Tween.TRANS_LINEAR)

func _on_lift_timer_timeout():
	print("go back to the postion")
	_cabine_position_function(lift_cabine, 0.0)
