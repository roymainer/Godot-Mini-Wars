extends Area2D


const TURN_SPEED = 180


export (int) var M = 3  # movement
#export (int) var WS
#export (int) var BS
#export (int) var S
#export (int) var T
#export (int) var W
#export (int) var I
#export (int) var A
#export (int) var LD
export (int) var models  # number of models in unit

var id  # unique unit id
var is_selected := false
var is_mouse_in := false
var is_alive := true
var is_moving := false
var target = null setget set_target, get_target
var velocity := Vector2()
var move_target := Vector2()


func _ready():
	pass
	
		
func _process(delta: float) -> void:
	if not is_alive:
		return
	control()
	_update(delta)
#	print("rotation: " + str(global_rotation_degrees))
	pass
	
	
func control():
	# virtual method
	pass
	
		
func _update(delta) -> void:

	if target == null and move_target == Vector2():
		return

	if target != null:
		move_target = target.get_position()
	
	# move to target
	if move_target.distance_to(global_position) < M: 
	 	# if close to target, stop
		stop_moving()
	else:
		# else, rotate and move to target
		var rotated = rotate_to_target(delta)
		if rotated or is_moving:
			move_to_target()
			
	
	pass

func set_target(unit):
	target = unit
	pass
	
func get_target():
	return target
	
func set_move_target(target_vector):
	is_moving = false
	move_target = Vector2() + target_vector
#	print(name + " move to: " + str(target_vector))
	pass

func rotate_to_target(delta):
	# returns true if unit faces the target (ready to move)
	var prev_rotation = global_rotation
	var target_dir = (move_target - global_position).normalized()  # get the target direction normal
	var current_dir = Vector2(1,0).rotated(global_rotation)  # current direction
	global_rotation = current_dir.linear_interpolate(target_dir, M * delta * 2).angle()
	return (prev_rotation == global_rotation)  # return true if unit faces target position

func rotate_sprite():
	var sprite = $Sprite
	sprite.rotation_degrees -= global_rotation_degrees
#	if global_rotation_degrees < 0:
#		sprite.rotation_degrees = 
#	sprite.rotation_degrees = global_rotation

func move_to_target():
	is_moving = true
	var target_dir = (move_target - global_position).normalized()  # get normalized direction vector to target
	velocity = target_dir * M
	position += velocity
	pass
	
func stop_moving():
	if is_moving:
		is_moving = false
		rotate_sprite()  # make sure the sprite is always straight
	pass	

func get_position() -> Vector2:
	return global_position

func _on_Unit_mouse_entered() -> void:
	is_mouse_in = true
	emit_signal("area_entered", self)
	
func _on_Unit_mouse_exited() -> void:
	is_mouse_in = false
	emit_signal("area_exited", self)
