extends Node

const UP = Vector2(0,-1)
const DOWN = Vector2(0, 1)

# formation constants
const SPACE_BETWEEN_UNITS = 6  # space between units in pixels
const MIN_MODELS_IN_ROW = 4  # minimal number of models row
const ARMY_NORMAL_SIZE = 20

func _ready():
	pass

func calc_normal(v1 : Vector2) -> Vector2:
	var v2 = Vector2(v1.y, -v1.x)  # flip the coordinates
	var normal = v2.normalized()
	return normal
	