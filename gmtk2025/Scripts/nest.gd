extends StaticBody2D

const PARTICLES := preload("res://Scenes/vfx_explosion.tscn")

signal satisfied

func _on_looped():
	satisfied.emit()
	var web_instance = PARTICLES.instantiate()
	web_instance.position = position
	GameManager.game_root.add_child(web_instance)
	queue_free()
