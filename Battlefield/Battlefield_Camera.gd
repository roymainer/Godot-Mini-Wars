extends Camera2D

onready var interface = $Battlefield_Interface/Units_Panel

func _ready():
	var sprite = Sprite.new()
	sprite.texture = load("res://icon.png")
	interface.add_item("debug", sprite.texture, true)
	pass
