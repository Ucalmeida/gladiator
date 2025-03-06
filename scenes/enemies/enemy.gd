class_name Enemy
extends Node

@export var health = 100
@export var max_health = 100

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health

func apply_damage():
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blink_intensity, 1.0, 0.0, 0.5)

func set_shader_blink_intensity(new_value : float):
	animated_sprite_2d.material.set_shader_parameter("blink_intensity", new_value)

func _on_hurt_box_area_entered(hitbox: Hitbox):
	apply_damage()
	health -= hitbox.damage
	health_bar.value = health
	if health <= 0:
		queue_free()
