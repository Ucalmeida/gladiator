extends Node2D

@export var shoot_speed = 1.0

const LASERPROJECTILE = preload("res://scenes/weapons/bullets/laserprojectile/laserprojectile.tscn")

@onready var market_2d = $Marker2D
@onready var shoot_speed_timer: Timer = $shootSpeedTimer

var can_shoot = true
var bullet_direction = Vector2(1, 0)

func _ready() -> void:
	shoot_speed_timer.wait_time = 1.0 / shoot_speed

func shoot():
	if can_shoot:
		can_shoot = false
		shoot_speed_timer.start()
		
		var bullet_node = LASERPROJECTILE.instantiate()
		bullet_node.set_direction(bullet_direction)
		get_tree().root.add_child(bullet_node)
		bullet_node.global_position = market_2d.global_position
	


func _on_shoot_speed_timer_timeout() -> void:
	can_shoot = true
	
func setup_direction(direction):
	bullet_direction = direction
	
	if direction.x > 0:
		scale.x = 1
		rotation_degrees = 0
	elif direction.x < 0:
		scale.x = -1
		rotation_degrees = 0
	elif direction.y < 0:
		scale.x = 1
		rotation_degrees = -90
	elif direction.x > 0:
		scale.x = 1
		rotation_degrees = 90
