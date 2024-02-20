extends Control
#
#
#@onready var CNETER = $center/CENTER
#@onready var LEFT = $center/LEFT
#@onready var TOP = $center/TOP
#@onready var RIGHT = $center/RIGHT
#@onready var BOTTOM = $center/BOTTOM
#
#
#var growpos = 35
#var growspeed = 4
#
#func _physics_process(delta):
	#if Input.is_action_pressed("shoot"):
		#RIGHT.position = lerp(RIGHT.position, Vector2(growpos, 0), growspeed * delta)
		#BOTTOM.position = lerp(BOTTOM.position, Vector2(0, growpos), growspeed * delta)
		#LEFT.position = lerp(LEFT.position, Vector2(-growpos, 0), growspeed * delta)
		#TOP.position = lerp(TOP.position, Vector2(0, -growpos), growspeed * delta)
	#else:
		#RIGHT.position = lerp(RIGHT.position, Vector2(10, 0), growspeed * delta)
		#BOTTOM.position = lerp(BOTTOM.position, Vector2(0, 10), growspeed * delta)
		#LEFT.position = lerp(LEFT.position, Vector2(-10, 0), growspeed * delta)
		#TOP.position = lerp(TOP.position, Vector2(0, -10), growspeed * delta)
