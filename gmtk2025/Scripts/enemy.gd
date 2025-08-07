extends CharacterBody2D

const PARTICLES := preload("res://Scenes/vfx_explosion.tscn")

@export var enemyHealth : float = 3
@export var enemySpeed : float = 5000
var health : float
var start_direction : Vector2
var direction : Vector2
var webbed : bool = false

func _lose_health():
	health -= 1
	if health <= 0:
		_to_webbed_state()
	
func _on_looped():
	queue_free()
	
func _to_webbed_state():
	webbed = true
	$Timer.start()
	await $Timer.timeout
	_die()
	
func _die():
	var particles = PARTICLES.instantiate()
	particles.position = position
	GameManager.game_root.add_child(particles)
	queue_free()
	
func _ready():
	$Spawn.play()
	health = enemyHealth	
	start_direction = Vector2(randi_range(-1,1), randi_range(-1,1));
	direction = start_direction
	rotation = direction.angle()
	$Area.connect("body_entered", Callable(self, "_on_body_collision"))
	$Area.connect("area_entered", Callable(self, "_on_body_collision"))

func _on_body_collision(body):
	if body.is_in_group("Player"):
		body._lose_health()
	if body.get_parent().is_in_group("Web"):
		body.get_parent()._on_destroyed()
		
func _physics_process(delta: float):
	if webbed:
		return
	velocity = Vector2.RIGHT.rotated(rotation).normalized() * enemySpeed * delta
	
	var collision = move_and_collide(velocity)
	if collision:
		var normal = collision.get_normal()
		direction = direction.bounce(normal).normalized()
		rotation = direction.angle()
	
