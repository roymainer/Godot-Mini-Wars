extends Node2D

var units = []
var starting_position := Vector2()

var marked_unit = null  # the unit hovered by the mouse
var selected_unit = null  # selected unit

func _ready():
	pass
	
func _process(delta: float) -> void:
	_control()
	pass

func _control():
	pass

func set_army_starting_position(pos):
	starting_position = pos

func set_army_formation():
	pass
	
func on_unit_marked(unit) -> void:
	marked_unit = unit
	pass
	
func on_unit_unmarked(unit) -> void:
	if marked_unit == unit:
		marked_unit = null
	pass

func get_units():
	return units