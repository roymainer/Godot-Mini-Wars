"""
Model.tscn
"""

extends KinematicBody2D

export (int) var M = 3  # movement
#export (int) var WS
#export (int) var BS
#export (int) var S
#export (int) var T
#export (int) var W
#export (int) var I
#export (int) var A
#export (int) var LD

var alive = true
var velocity = Vector2()
var target = null setget set_target, get_target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if not alive:
		return

	control(delta)
	move_and_slide(velocity)


func control(delta):
	if target != null:
		var movement_speed = M * 10
		
		if position.distance_to(target) < 1:
			global_rotation = get_parent().get_normal().angle()
			velocity = Vector2()
		else:
			var target_dir = (target - global_position).normalized()  # get target position normalized
			var current_dir = Vector2(1,0).rotated(global_rotation)  # current turret direction (a rotated unit vector)
			global_rotation = current_dir.linear_interpolate(target_dir, movement_speed * delta).angle()
			velocity = Vector2(movement_speed, 0).rotated(rotation)


func set_target(_target) -> void:
	target = _target	


func set_direction(normal)	-> void:
	global_rotation = normal.angle()

func get_target() -> Vector2:
	return target

	
func get_diameter() -> float:
	return $CollisionShape2D.shape.radius * 2


func get_position() -> Vector2:
	return position
