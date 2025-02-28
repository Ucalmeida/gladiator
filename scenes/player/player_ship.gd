extends CharacterBody2D

# Variáveis de movimento
var speed = 700

# Variáveis de escudo e vida
var shield = 100
var max_shield = 100
var health = 100
var max_health = 100
var shield_regen_rate = 5  # Regenera 5 por segundo

# Referências aos nós
@onready var shield_bar = $ShieldBar
@onready var health_bar = $HealthBar

func _ready():
	# Inicializa as barras
	shield_bar.max_value = max_shield
	shield_bar.value = shield
	health_bar.max_value = max_health
	health_bar.value = health

func _process(_delta):
	# Movimento com WASD
	var input_dir = Vector2.ZERO
	if Input.is_key_pressed(KEY_W):
		input_dir.y -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.y += 1
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_D):
		input_dir.x += 1
	
	# Normaliza a direção para evitar movimento mais rápido na diagonal
	velocity = input_dir.normalized() * speed

	# Direcionamento com o mouse
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	rotation = direction.angle()

	# Disparo com a tecla Espaço
	if Input.is_key_pressed(KEY_SPACE):
		shoot()

func _physics_process(delta):
	# Move a nave
	move_and_slide()

	# Regenera o escudo
	if shield < max_shield:
		shield += shield_regen_rate * delta
		shield = min(shield, max_shield)
		shield_bar.value = shield

func shoot():
	# Lógica básica de tiro (projétil será criado depois)
	print("Tiro disparado!")

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
