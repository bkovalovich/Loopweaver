extends CharacterBody2D
class_name Player

const WEB_SHOOT_SCENE := preload("res://Scenes/web_shot.tscn")

@export var movement_speed : float = 300
@export var player_health : float = 5
@export var web : WebManager

var direction : Vector2
var lastDirection : Vector2
var health : float
var on_post : Web
var dead : bool = false

func _ready():
	health = player_health
	web._create_segment(self.position)
	
func _lose_health():
	health -= 1	
	if health <= 0:
		_die()
	$HurtSound.play()
	$Sprite.modulate = Color(255,0,0)
	$Timer.start()
	await $Timer.timeout
	var tween = create_tween()
	tween.tween_property($Sprite, "modulate", Color(255,255,255), 1)
	
func _die():
	dead = true
	$Dead.play()
	var tween = create_tween()
	tween.tween_property($Sprite, "rotation", 6.28319, 1.5)
	await tween.finished
	GameManager._end_game()

func _physics_process(delta):
	if !dead: 
		_movement(delta)
		_post(delta)
		_shoot(delta)

func _movement(delta):
	direction.y = Input.get_axis("move_up","move_down")
	direction.x = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity = direction.normalized() * movement_speed * delta
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
	move_and_slide()
	_adjust_sprite()
	lastDirection = direction
	
func _post(delta):
	#print(str(on_post))
	if Input.is_action_just_pressed("place_post"):
		if on_post != null: #close loop if not on post
			web._close_loop(on_post)
			#on_post = null
		else: #place new post if not on post
			web._create_segment(self.position)
	elif web.head_web != null: #update head node's position with current pos
		web.head_web.end_node = self.position
		#web.head_web._toggle


func _shoot(delta):
	if Input.is_action_just_pressed("shoot"):
		var web_instance = WEB_SHOOT_SCENE.instantiate()
		web_instance.Direction = (get_global_mouse_position() - global_position).normalized()
		web_instance.position = position
		web_instance.player = self
		GameManager.game_root.add_child(web_instance)
		
func _adjust_sprite():
	if lastDirection == direction:
		return
	#PROPER SPRITE
	match direction:
		Vector2(1,0):
			$Sprite.animation = "walk_horiz"
			$Sprite.flip_h = true
		Vector2(-1,0):
			$Sprite.animation = "walk_horiz"
			$Sprite.flip_h = false
		Vector2(0,-1):
			$Sprite.animation = "walk_up"
			$Sprite.flip_h = false
		Vector2(-1,1):
			$Sprite.animation = "walk_diag_down"
			$Sprite.flip_h = false
		Vector2(1,1):
			$Sprite.animation = "walk_diag_down"
			$Sprite.flip_h = true
		Vector2(-1,-1):
			$Sprite.animation = "walk_diag_up"
			$Sprite.flip_h = false
		Vector2(1,-1):
			$Sprite.animation = "walk_diag_up"
			$Sprite.flip_h = true
		Vector2(0,1):
			$Sprite.animation = "walk_down"
			
	#IDLE SPRITE
	if direction == Vector2(0,0):
		$Sprite.frame = 0
		$Sprite.stop()
	else:
		$Sprite.play()
			
