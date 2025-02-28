extends Area2D

var damage: float = 10.0
var speed: float = 800.0
var owner_id: int = 0  # ID do jogador que disparou o projétil
var velocity: Vector2 = Vector2.ZERO

func initialize(shooter_id: int, direction: Vector2):
	owner_id = shooter_id
	rotation = direction.angle()
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage") and body.player_id != owner_id:
		body.take_damage(damage, owner_id)
		queue_free()
