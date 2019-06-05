extends Control

onready var units_panel = $Units_Panel
onready var selected_unit_panel = $Selectet_Unit_Panel

var id = 0

func _ready():
	units_panel.set_max_columns(40)
	units_panel.set_fixed_icon_size(Vector2(48, 48))
	units_panel.set_icon_mode(ItemList.ICON_MODE_TOP)
	units_panel.set_select_mode(ItemList.SELECT_MULTI)
	units_panel.set_same_column_width(true)
	
	var sprite = Sprite.new()
	sprite.texture = load("res://icon.png")
	units_panel.add_item("debug", sprite.texture, true)
	
	selected_unit_panel.texture = sprite.texture
	
	pass

func add_unit_icon(unit_name, unit_icon):
	units_panel.add_item(unit_name, unit_icon.texture, true)
	print("ItemList: " + units_panel.get_item_text(1))