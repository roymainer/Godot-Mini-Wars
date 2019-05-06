""" 
Unit.tscn
"""

extends Node2D

export (int) var max_unit_size
#export (PackedScene) var model_type

onready var model_type = preload("res://Models/Model.tscn")

var models = []

var model_diameter := 0.0
var unit_size  # current unit size
var models_in_row = Globals.MIN_MODELS_IN_ROW  # default

var is_drawing := false  # true when player is assigning move command

# formation drawing
var tmp_start_point := Vector2()
var tmp_end_point := Vector2()
var tmp_front_line_vector := Vector2()
var tmp_front_line_middle := Vector2()
var tmp_front_line_normal := Vector2()
var tmp_move_targets = []

# current unit formation
var start_point := Vector2()
var end_point := Vector2()
var front_line_vector := Vector2()
var front_line_middle := Vector2()
var front_line_normal := Vector2()
var move_targets = []


func _ready():
	model_diameter = get_model_diameter()
	unit_size = max_unit_size
	
	# populate list of models
#warning-ignore:unused_variable
	for i in range(unit_size):
		var model = model_type.instance()
		models.append(model)
#		get_parent().call_deferred("add_child", model)
		add_child(model)


func _process(delta):
	
	_control(delta)
	update()
	pass
	
	
#warning-ignore:unused_argument
func _control(delta):
	
	if is_drawing:
		calc_front_line_vectors()
		calc_formation()
	
	pass
	

func _draw():
	# drawing is only possible inside _draw function
	if is_drawing:
		draw_line(tmp_start_point, tmp_end_point, Color(0, 255, 0), 5)  # draw front line
#		draw_line(tmp_front_line_middle, tmp_front_line_middle + tmp_front_line_normal, Color(255, 255, 0), 5)  # draw front line normal (unit facing direction)

	#	# draw unit formation & target position
		for i in range(tmp_move_targets.size()):
			var pos = tmp_move_targets[i]
			draw_circle(pos, model_diameter/2, Color(255,255,0))
	pass


func calc_front_line_vectors():
	# TODO: need to update tmp_start/stop points (Army needs to do this once it divides the front line vector)
	tmp_front_line_vector = Vector2(tmp_end_point.x - tmp_start_point.x, tmp_end_point.y - tmp_start_point.y)  # line vector from start point to mouse point
	tmp_front_line_middle = tmp_start_point + (tmp_front_line_vector / 2)  # calc middle point
	tmp_front_line_normal = Globals.calc_normal(tmp_front_line_vector) * model_diameter  # calc normal to frontline vector

func calc_formation():
	"""
	sets a temporary formation based on two points that define the unit's front line vector
	"""
	
	tmp_move_targets.clear()  # clear any previous list of move targets
	
	var tmp_models_in_row = calc_models_in_row(tmp_start_point, tmp_end_point)  # calc temporary #models in row
	var col_dv = (tmp_front_line_vector / tmp_models_in_row).normalized() * model_diameter  # get a delta of the line vector for each model in the row
	var row_dv = tmp_front_line_normal
	
	for i in range(unit_size):
		var col = i % tmp_models_in_row
		var row = int(i / tmp_models_in_row)
		var pos = tmp_start_point + (col * col_dv) - (row * row_dv)
		tmp_move_targets.append(pos)
	return


func set_move_command(immediate_move):
	# once the user released the right mouse button, the unit formation is set and it can move to target
	front_line_vector = tmp_front_line_vector
	front_line_middle = tmp_front_line_middle
	front_line_normal = tmp_front_line_normal
	start_point = tmp_start_point
	end_point = tmp_end_point
	
	move_targets = [] + tmp_move_targets
	
	move_to_target(immediate_move)
	
	return
	

func calc_models_in_row(p0, p1):
	var distance = p0.distance_to(p1)
	var number_of_models = int(floor(distance / model_diameter))
	if number_of_models < Globals.MIN_MODELS_IN_ROW:
		number_of_models = Globals.MIN_MODELS_IN_ROW
#	print("p0: " + str(p0) + ", p1: " + str(p1) + ", distance: " + str(distance) + ", diameter: " + str(model_diameter) + ", #models: " + str(number_of_models))
	return number_of_models


func clear_move_target():
	move_targets.clear()
	return


func move_to_target(immediate_move):
	if move_targets.size() == 0:
		return

	for index in range(unit_size):
		var target = move_targets[index]
#		print(target)
		if immediate_move:
			# in pre-combat stage, units immediatly appear in set position
			models[index].position = target
			models[index].set_direction(front_line_normal)
		else:
			# in combat stage units need to move to new target
			models[index].set_target(target)
	return



func set_start_point(point) -> void:
	tmp_start_point = start_point
	start_point = point
	

func get_model_diameter() -> float:
	# get model diameter
	var model = model_type.instance()
	var _diameter = model.get_diameter()
	model.queue_free()
	return _diameter

	

func get_model_zero_position() -> Vector2:
	return models[0].get_position()


func get_unit_column_vector() -> Vector2:
	""" 
	Returns a vector that represents the units' length
	Used for alinging another unit at the back of the current unit
	"""
	var max_row = int(unit_size / models_in_row)  # number of rows in unit current formation
	var edge_model_index = max_row * models_in_row  # the model at the end of the leftmost column (1st column)
	var column_vector = models[edge_model_index].get_position() - models[0].get_position()
	return column_vector


func get_normal() -> Vector2:
	return front_line_normal
	

func get_icon():
	var sprite = Sprite.new()
	sprite.texture = load("res://icon.png")
	return sprite
