extends CharacterBody2D
var pos: Vector2
var rota: float
var dir : float = 0.0
var speed = 4000
var z_dex : int

func _ready():
	global_position = pos
	global_rotation = rota
	z_index = z_dex

func _physics_process(_delta):
	velocity = Vector2(speed, 0).rotated(dir)
	move_and_slide()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("HIT!!")
	queue_free()


func _on_life_timeout() -> void:
	queue_free()
