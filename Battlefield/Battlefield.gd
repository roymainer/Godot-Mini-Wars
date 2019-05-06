"""
Battlefield.tscn
"""

extends Node2D

onready var camera = $Camera2D
onready var screensize = get_viewport_rect().size


func _ready():
	set_camera_limits()

func _input(event):
	if event.is_action_pressed("scroll_up"):
		camera.zoom -= Vector2(0.1, 0.1)
	if event.is_action_pressed("scroll_down"):
		camera.zoom += Vector2(0.1, 0.1)
		if camera.zoom > Vector2(2,2):
			camera.zoom = Vector2(2,2)
	
		
func set_camera_limits():
	var map_limits = $Background.get_rect()
	camera.limit_left = map_limits.position.x
	camera.limit_right = map_limits.end.x
	camera.limit_top = map_limits.position.y
	camera.limit_bottom = map_limits.end.y