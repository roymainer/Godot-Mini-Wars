extends KinematicBody2D

var alive = true
var target := Vector2() setget set_target
var velocity = Vector2()

func _ready():
	pass
	
func _physics_process(delta):
	if not alive:
		return

	control(delta)
	move_and_slide(velocity)

func control(delta):
	if target != null:
		var target_dir = (target - global_position).normalized()  # get target position normalized to enemy tank position
		var current_dir = Vector2(1,0).rotated(global_rotation)  # current turret direction (a rotated unit vector)
		var model = model_
		var movement_speed = 
		global_rotation = current_dir.linear_interpolate(target_dir, movement_speed * delta).angle()
		velocity = Vector2(movement_speed, 0).rotated(rotation)
	
func get_radius():
	return $CollisionShape2D.shape.radius
	
func set_target(_target):
	target = _target	