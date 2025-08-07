extends Node
var game_root: Node2D
var player: Player

const BOSS_SCENE := preload("res://Scenes/Boss_Game.tscn")
const NEST_SCENE := preload("res://Scenes/Nest_Game.tscn")
var scenes : Array[PackedScene] = [BOSS_SCENE, NEST_SCENE]
var level : int

func _load_scene():
	var scene = scenes[randi() % scenes.size()]
	get_tree().change_scene_to_packed(scene)
	
func _start_game():
	level = 1
	_load_scene()
	
func _level_complete():
	level += 1
	_load_scene()

func _end_game():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
