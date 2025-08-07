extends CharacterBody2D

@export var bullet_speed : float
var player : Player
var direction : Vector2
var Direction: Vector2:
	set(value):
		direction = value
		rotation = direction.angle()
#
func _ready():
	$Area.connect("body_entered", Callable(self, "_on_body_collision"))
#
func _on_body_collision(body):
	if body.is_in_group("Enemy"):
		if body.webbed == true:
			player.position = body.position
			body._die()
		body._lose_health()
	if !body.is_in_group("Player"):
		queue_free()

func _physics_process(delta: float):
	velocity = Vector2.RIGHT.rotated(rotation).normalized() * bullet_speed * delta
	move_and_collide(velocity)
	#if collision:
		#var normal = collision.get_normal()
		#direction = direction.bounce(normal).normalized()
		#rotation = direction.angle()
	
		#print("collided, adding point")
		#web._add_point(post_root)
