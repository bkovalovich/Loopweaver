extends Area2D
class_name Check

func _update_points(webs : Array[Web]):
	var points : Array[Vector2]
	for web in webs:
		points.append(web.end_node)
		print(str(web.position))
	$Collision.polygon = points
	
func _ready():
	connect("body_entered", Callable(self, "_on_body_collision"))
	_disable_after(0.5)
#
func _on_body_collision(body):
	if body.is_in_group("Enemy") || body.is_in_group("WinCon"):
			body._on_looped()
			

func _disable_after(time : float):
		await get_tree().create_timer(time).timeout
		process_mode = Node.PROCESS_MODE_INHERIT
