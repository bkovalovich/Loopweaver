extends Node2D


func _on_start_pressed() -> void:
	GameManager._start_game()
	#get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
