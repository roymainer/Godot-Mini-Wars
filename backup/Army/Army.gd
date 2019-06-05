""" 
Army.tscn

This scene controls the units of a certain army
"""

extends Node2D

# Game flags
var pre_combat_stage = true  # player sets army formation before combat starts

# control
var mouse_pos = Vector2()

# Units
onready var unit_type = preload("res://Units/Unit.tscn")
var units = []
var selected_units = []

# selected units formation
var front_line_start_point = Vector2()
var front_line_end_point = Vector2()
var front_line_vector = Vector2()  
var front_line_middle_point = Vector2()  # middle of the front line
var front_line_normal = Vector2()  # the direction where the models are facing

var prev_front_line_start_point = Vector2()

# Formation
var is_drawing = false  # flag for drawing the units formations and movement paths


func _ready():
	for i in range(4):
		var unit = unit_type.instance()
		units.append(unit)
		add_child(unit)
	selected_units = [] + units
	pass

func _process(delta):
	_control()
	
	if is_drawing:
		calc_front_line_vectors(mouse_pos)
	
		
	update()
	return

func _control():
	
	mouse_pos = get_global_mouse_position()  # update mouse position
	mouse_pos.x = int(mouse_pos.x)
	mouse_pos.y = int(mouse_pos.y)
	
	if Input.is_action_just_pressed("mouse_click_l"):
		# TODO: add selected units or clear selected units
		pre_combat_stage = !pre_combat_stage
		pass
		
	if Input.is_action_just_pressed("mouse_click_r"):
		# first click, issue move or attack command
		if not selected_units.empty():
			set_front_line_start_point(get_global_mouse_position())
		is_drawing = true
		
	if Input.is_action_just_released("mouse_click_r"):
		# sets the units positions according to formation drawn
		if not selected_units.empty():
			set_army_move_command()
		is_drawing = false  # disable drawing, formation is set to all selected units
		print("s-1: {}, s0: {}, m0: {}, v0: {}".format([prev_front_line_start_point, front_line_start_point, front_line_middle_point, front_line_vector], "{}") )

	# update is_drawing for each selected unit
	for unit in selected_units:
		unit.is_drawing = is_drawing

	pass


func _draw():
	# drawing a line is only possible inside a _draw function
	if is_drawing:
		draw_line(front_line_start_point, mouse_pos, Color(255,255,255), 5)  # draw frontline
		draw_line(front_line_middle_point, front_line_middle_point + front_line_normal, Color(255, 255, 0), 5)  # draw normal (direction)
		
		# debug
		draw_line(prev_front_line_start_point, front_line_start_point, Color(255, 255, 255), 3)
	return


func calc_front_line_vectors(end_point):
	""" calculates the front line vectors using the end_point (usually mouse click pos) and current position """
	
	if (mouse_pos - front_line_start_point).length() < Globals.SPACE_BETWEEN_UNITS:
		# user clicked and released on a single point without drawing a new formation
		# move the army to the new point (front_line_vector_middle (prev) -> (new))
		var move_vector = Vector2(mouse_pos.x - prev_front_line_start_point.x, mouse_pos.y - prev_front_line_start_point.y)  # move middle to new point
		front_line_start_point = prev_front_line_start_point + move_vector # update the "new" front line start position for move method
		end_point = front_line_start_point + front_line_vector  # modify the mouse position that sets the future front line so that the formation remains the same


	front_line_vector = end_point - front_line_start_point
	front_line_middle_point = front_line_start_point + (front_line_vector / 2)  # calc middle point 
	front_line_normal = Globals.calc_normal(front_line_vector) * Globals.ARMY_NORMAL_SIZE  # calc normal to frontline vector
	
#	var num_units_in_front_line = get_number_of_units_in_front_line()  # returns number of units that can fit in the front line
	var num_units_in_front_line = selected_units.size()  # returns number of units that can fit in the front line
	var units_space_vector = get_unit_space_vector()  # space between each two units
	var total_space_between_units = (num_units_in_front_line - 1) * units_space_vector  # part of the front line vector used for space between units
	
	# divide front line vector to the number of front line units, after subtracting the spaces between them
	var unit_front_vector = (front_line_vector - total_space_between_units) / num_units_in_front_line  
	
	# assigne start and end point to each unit
	var unit_start_point = Vector2()
	var unit_end_point = Vector2()
	
	for i in range(selected_units.size()):
		var unit = selected_units[i]  # get current unit
		var col = i % num_units_in_front_line  
		
		# calc start and end points
		unit_start_point = front_line_start_point + (unit_front_vector + units_space_vector) * col
		unit_end_point = unit_start_point + unit_front_vector  # set end point

		# assign each unit's start, end point and normal direction
		unit.tmp_start_point = unit_start_point
		unit.tmp_end_point = unit_end_point
		unit.tmp_front_line_normal = front_line_normal
	
	return


func calc_minimal_front_line(_units):
	var minimal_front_line = 0
	for unit in _units:
		minimal_front_line += unit.models_in_row * unit.get_model_diameter()
		minimal_front_line += Globals.SPACE_BETWEEN_UNITS  # create space between units
	return minimal_front_line
	

func set_army_move_command():
	""" assign new move command to all selected units according to drawn formation """
	for unit in selected_units:
		unit.set_move_command(pre_combat_stage)  # assign move target
	return
	

func set_front_line_start_point(point):
	prev_front_line_start_point = front_line_start_point
	front_line_start_point = point 
	pass
	

func get_number_of_units_in_front_line():
	"""
	This method returns the maximal number of selected units that can fit in the front line
	"""
	
	var tmp_units = [] + selected_units  # copy the selected units list
	var tmp_size = tmp_units.size()  # number of units in front row
	var minimal_front_line = calc_minimal_front_line(tmp_units)  # calculate minimal front line
	var spaces_vectors = get_unit_space_vector() * (tmp_units.size() - 1)  # subtract the spaces between the units
	var front_line_length = front_line_vector.length() - spaces_vectors.length()
	
	while not minimal_front_line < front_line_length:
		tmp_units.pop_front()
		tmp_size = max(tmp_units.size(), 1)  # front line must have at least 1 unit
		minimal_front_line = calc_minimal_front_line(tmp_units)
	
	return tmp_size
	
	
func get_unit_space_vector() -> Vector2:
	"""
	return a fixed size vector that represents the space between front line units
	"""
	var space_vector = Vector2()
	var normalized_flv = front_line_vector.normalized() 
	space_vector = normalized_flv * Globals.SPACE_BETWEEN_UNITS
	return space_vector