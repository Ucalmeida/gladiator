extends CharacterBody2D

@export var shoot_cooldown = 0.5
# LaserBeam
#var laser_beam: RayCast2D

# Projectiles
const FIRE_BULLET = preload("res://scenes/weapons/bullets/fire/fire_bullet.tscn")

# Variáveis de movimento
var speed = 500

# Variáveis de escudo e vida
var shield = 100
var max_shield = 100
var health = 100
var max_health = 100
var shield_regen_rate = 5  # Regenera 5 por segundo

# Variáveis controle de tiro
var is_ready = false
var can_shoot = true

# Referências aos nós
@onready var shield_bar = $ShieldBar
@onready var health_bar = $HealthBar
@onready var sprite = $Ship

func _ready():
	#if not laser_beam:
		#laser_beam = $LaserBeam
	#laser_beam.set_physics_process(false)
	
	# pequeno atraso para evitar disparos acidentais
	await get_tree().create_timer(0.1).timeout
	is_ready = true
	
	# Inicializa as barras
	shield_bar.max_value = max_shield
	shield_bar.value = shield
	health_bar.max_value = max_health
	health_bar.value = health

func _process(_delta):
	# Disparo com a tecla Espaço
	if is_ready and can_shoot and (Input.is_key_pressed(KEY_SPACE) or Input.is_action_just_pressed("shoot")):
		shoot()
		cooldown()

func _physics_process(delta):
	# Acompanha o movimento do mouse na tela
	look_at(get_global_mouse_position())
	
	# Velocidade de movimentação Teclado
	velocity.x = Input.get_axis("move_left", "move_right") * speed
	velocity.y = Input.get_axis("move_up", "move_down") * speed
	
	# Função lerp de velocidade
	velocity = lerp(get_real_velocity(), velocity, 0.1)
	
	# Aplica aceleração se houver input
	#if input_dir.length() > 0:
		#var velocity_dir = velocity.normalized()
		#var dot_product = input_dir.dot(velocity_dir)
		#if dot_product < -0.5 and velocity.length() > 0:  # Input oposto
			#velocity = velocity.lerp(input_dir * speed, acceleration * delta)
		#else:
			#velocity += input_dir * acceleration * delta
		#velocity = velocity.limit_length(speed)
	#else:
		## Aplica fricção para desacelerar quando não há input
		#var velocity_length = velocity.length()
		#if velocity_length > 0:
			#var friction_force = min(friction * delta, velocity_length)
			#velocity -= velocity.normalized() * friction_force
			#if velocity.length() < 5.0:
				#velocity = Vector2.ZERO
	
	# Joystick (analógico direito)
	#var joy_direction_x = Input.get_axis("turn_down", "turn_up")
	#var joy_direction_y = Input.get_axis("turn_left", "turn_right")
	#var joy_direction = Vector2(joy_direction_x, joy_direction_y).normalized()
	
	# Escolhe entre mouse e joystick (prioridade ao joystick se usado)
	#if joy_direction.length() > 0.1:  # Deadzone para evitar ruído
		#direction = joy_direction
		#target_rotation = direction.angle()
	#else:
		#direction = mouse_direction
		#target_rotation = direction.angle()
	#
	## Interpolação suave da rotação
	#current_rotation = lerp_angle(current_rotation, target_rotation, rotation_speed * delta)
	#rotation = current_rotation
	
	# Move a nave
	move_and_slide()

	# Regenera o escudo
	if shield < max_shield:
		shield += shield_regen_rate * delta
		shield = min(shield, max_shield)
		shield_bar.value = shield

func shoot() -> void:
	# Lógica básica de tiro
	var projectile = FIRE_BULLET.instantiate()
	projectile.global_position = global_position
	projectile.global_rotation = global_rotation
	get_parent().add_child(projectile)
	
	# Lógica Laser_Beam
	#if laser_beam:
		#laser_beam.set_is_casting(is_firing)
	

func take_damage(amount):
	if shield > 0:
		shield -= amount
		if shield < 0:
			health += shield  # Dano excedente vai pra vida
			shield = 0
	else:
		health -= amount
	
	# Atualiza as barras
	shield_bar.value = shield
	health_bar.value = health
	
	if health <= 0:
		destroy_ship()

func destroy_ship():
	# Lógica de destruição (explosão será adicionada depois)
	queue_free()  # Remove a nave

# Para testar o dano com uma tecla (ex.: Q)
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Tecla Q, por exemplo
		take_damage(20)

# Cooldown para atirar
func cooldown() -> void:
	can_shoot = false
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true
