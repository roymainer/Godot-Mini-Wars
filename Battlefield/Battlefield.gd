extends Node2D

# camera
onready var camera = $Camera2D
var camera_velocity = Vector2()
var camera_speed = 3

onready var fps_label = $Label

# armies
onready var player_army_node = preload("res://Army/PlayerArmy.tscn")
onready var computer_army_node = preload("res://Army/ComputerArmy.tscn")
var player_army
var computer_army

func _ready():
	player_army = player_army_node.instance()
	add_child(player_army)
	computer_army = computer_army_node.instance()
	add_child(computer_army)
	pass
	
func _process(delta: float) -> void:
	fps_label.set_text(str(Engine.get_frames_per_second()))
	camera_control()
	camera.position += camera_velocity * camera_speed
	pass
	
func _input(event):
	# camera zoom control
	if event.is_action_pressed("scroll_up"):
		camera.zoom -= Vector2(0.1, 0.1)
	if event.is_action_pressed("scroll_down"):
		camera.zoom += Vector2(0.1, 0.1)
		
func camera_control():
	# camera movement controls
	camera_velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		camera_velocity.y = -1
	if Input.is_action_pressed("ui_down"):
		camera_velocity.y = 1
	if Input.is_action_pressed("ui_left"):
		camera_velocity.x = -1
	if Input.is_action_pressed("ui_right"):
		camera_velocity.x = 1
	pass
	
func get_player_units():
	return player_army.get_units()
	


