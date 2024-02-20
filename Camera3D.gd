extends Camera3D

var finalPosition: Vector3
var currentPosition: Vector3

var maxRecoil = 1
var recoilSpeed = 1.5
var returnSpeed = 4

@onready var ray_cast_3d = $RayCast3D

func _physics_process(delta):
	finalPosition = lerp(finalPosition, Vector3.ZERO, returnSpeed * delta)
	currentPosition = lerp(currentPosition, finalPosition, recoilSpeed * delta)
	rotation_degrees = currentPosition
	
	if Input.is_action_pressed("shoot"):
		applyRecoil()

func applyRecoil():
	var spread = 0.15
	var randomSpread = Vector3(randf_range(-spread, spread), randf_range(-spread, spread), 0)
	ray_cast_3d.position = randomSpread
	finalPosition.x += maxRecoil
