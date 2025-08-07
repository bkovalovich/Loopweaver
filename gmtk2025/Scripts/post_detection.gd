extends Area2D

var web : Web

func _ready():
	connect("body_entered", Callable(self, "_on_body_collision"))
	connect("body_exited", Callable(self, "_on_body_exit"))
	
func _on_body_collision(body):
	if body.is_in_group("Player"):
		body.on_post = web
	
func _on_body_exit(body):
	if body.is_in_group("Player"):
		body.on_post = null
