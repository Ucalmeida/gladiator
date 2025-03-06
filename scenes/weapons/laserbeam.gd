extends RayCast2D

@export var growth_time := 0.1

var is_casting: bool = false  : set = set_is_casting
@onready var fill : Line2D = $Line2D
var tween : Tween
@onready var line_width: float = fill.width

func _ready():
	set_physics_process(false)
	$Line2D.set_point_position(1, Vector2.ZERO)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		self.is_casting = event.pressed

func _process(_delta):
	pass

func _physics_process(_delta: float) -> void:
	var cast_point := target_position
	force_raycast_update()
	
	$CollisionParticles2D.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		$CollisionParticles2D.global_rotation = get_collision_normal().angle()
		$CollisionParticles2D.position = cast_point
	$Line2D.set_point_position(1, cast_point)
	$BeamParticles2D.position = cast_point * 0.5
	if $BeamParticles2D.process_material is ParticleProcessMaterial:
		$BeamParticles2D.process_material.emission_box_extents.x = cast_point.length() * 0.5

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	$BeamParticles2D.emitting = is_casting
	$CastingParticles2D.emitting = is_casting
	if is_casting:
		appear()
	else:
		$CollisionParticles2D.emitting = false
		disappear()
		
	set_physics_process(is_casting)
	
func appear() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", line_width, growth_time * 2)
	
func disappear() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0, growth_time).from_current()
