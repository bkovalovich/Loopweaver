extends Node2D

@export var player : Player
@export var margin : float
@export var win_cons : Array[Node2D]

var satisfied_cons : int = 0
const ENEMY_SCENE := preload("res://Scenes/enemy.tscn")

func _ready():
	GameManager.game_root = self
	GameManager.player = player
	$LevelText.text = "Level " + str(GameManager.level)
	$Camera2D.zoom = Vector2(1,1)
	$Camera2D.make_current()
	$SpawnTimer.start()
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	_create_wincons()

func _create_wincons():	
	for condition in win_cons:
		print("connected")
		condition.satisfied.connect(_on_satisfied)
		
func _on_satisfied():		
	print("satisfied")
	satisfied_cons += 1
	if(satisfied_cons >= win_cons.size()):
		$Success.play()
		await $Success.finished
		GameManager._level_complete()
		
func _random_spawnpoint() -> Vector2:
	var arena_pos = global_position
	var arena_size = Vector2(1152, 648)
	
	var top_left = arena_pos + Vector2(margin,margin)
	var top_right = arena_pos + Vector2(arena_size.x - margin, margin)
	var bottom_left = arena_pos + Vector2(margin, arena_size.y - margin)
	var bottom_right = arena_pos + arena_size - Vector2(margin, margin)
	var values : Array[Vector2] = [bottom_left, bottom_right, top_left, top_right]
	return values[randi_range(0, values.size()-1)]
		
func _on_spawn_timer_timeout():
	var enemy_instance = ENEMY_SCENE.instantiate()
	enemy_instance.global_position = _random_spawnpoint()
	add_child(enemy_instance)
	$SpawnTimer.start()
	
