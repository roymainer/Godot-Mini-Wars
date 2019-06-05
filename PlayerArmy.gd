extends "res://Army/Army.gd"

onready var player_unit_node = preload("res://Units/Player_Unit.tscn")
var player_unit

func _ready():
	player_unit = player_unit_node.instance()
	add_child(player_unit)
	connect_player_unit(player_unit)
	units.append(player_unit)
	pass
	
func _control() -> void:
	if Input.is_action_just_pressed("mouse_click_l"):
		if marked_unit != null:
			selected_unit = marked_unit
			print("Selected unit: " + selected_unit.name)
		pass
	if Input.is_action_just_pressed("mouse_click_r"):
		if selected_unit != null:
			if marked_unit == null:
				selected_unit.set_move_target(get_global_mouse_position())
			elif selected_unit != marked_unit:
				selected_unit.set_target(marked_unit)
	pass				

func connect_player_unit(unit) -> void:
	unit.connect("area_entered", self, "on_unit_marked")
	unit.connect("area_exited", self, "on_unit_unmarked")
	pass