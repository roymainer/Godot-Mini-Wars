extends Node2D

var start_point = Vector2()
var end_point = Vector2()
var is_drawing = false

func _ready():
	pass

func control() -> Array:
	if Input.is_action_just_pressed("mouse_click_l"):
		# TODO: add selected units or clear selected units
		pass
	if Input.is_action_just_pressed("mouse_click_r"):
		# first click, issue move or attack command
		start_point = get_global_mouse_position()
		is_drawing = true
	if Input.is_action_just_released("mouse_click_r"):
		# on right mouse button release, an end point is set
		end_point = get_global_mouse_position()
		is_drawing = false
	
	return [start_point, end_point, is_drawing]
	

