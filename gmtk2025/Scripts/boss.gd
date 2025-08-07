extends CharacterBody2D

@export var rotation_speed : float 
@export var speed : float 
signal satisfied

func _on_looped():
	print("looped")
	satisfied.emit()
	queue_free()

func _ready():
	$Area.connect("body_entered", Callable(self, "_on_body_collision"))
	$Area.connect("area_entered", Callable(self, "_on_body_collision"))

func _on_body_collision(body):
	if body.is_in_group("Player"):
		body._lose_health()
	if body.get_parent().is_in_group("Web"):
		body.get_parent()._on_destroyed() 
		
func shortest_angle_to(from_angle: float, to_angle: float) -> float:
	return wrapf(to_angle - from_angle, -PI, PI)
		
func _physics_process(delta: float):
	var player_pos = GameManager.player.global_position
	
	# Instantly face the player
	look_at(player_pos)
	
	# Move forward in the direction the boss is facing
	velocity = Vector2.RIGHT.rotated(rotation) * speed * delta
	move_and_slide()
