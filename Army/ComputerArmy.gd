extends "res://Army/Army.gd"

var computer_unit_node = preload("res://Units/ComputerUnit.tscn")
var computer_unit

func _ready() -> void:
	computer_unit = computer_unit_node.instance()
	add_child(computer_unit)
	units.append(computer_unit)
	pass
	
func _control():
	var player_units = get_parent().get_player_units()
	
	for unit in units:
		if unit.get_target() == null:
			# if a unit has no target, assign a target 
			var target = assign_unit_target(unit, player_units)  # find a target for current unit
			if target != null :
				unit.set_target(target)
			
func assign_unit_target(unit, player_units):
	# finds the best player unit for current unit to attack
	# needs more work, currently assigns the closest unit
	var min_dist = 99999  # default value
	var unit_pos = unit.global_position
	var target = null
	for punit in player_units:
		var dist = unit_pos.distance_to(punit.global_position)
		if dist < min_dist:
			min_dist = dist
			target = punit
	return target