extends Node2D

class_name Web

var start_node : Vector2
var end_node : Vector2
var prev_segment : Web

func _ready():
	$Start_Area.web = self
	$End_Area.web = self
	$Line_Area.process_mode = Node.PROCESS_MODE_DISABLED
	
func _toggle_end(toggle : bool):
	$End_Area.process_mode = Node.PROCESS_MODE_DISABLED if toggle else PROCESS_MODE_INHERIT   

func _set_nodes(start : Vector2, end : Vector2):
	start_node = start
	end_node = end

func check_prev(post : Web) -> bool:
	if self == post:
		return true
	else:
		return false

func _draw_line():
	if start_node == null || end_node == null:
		return
	var points : Array[Vector2] = [start_node,  end_node]
	$Start_Area.position = points[0]
	$End_Area.position = points[1]
	$Line.points = points

func make_collision_from_line():
	var o : float = 1
	var a = $Line.points[0]
	var b = $Line.points[1]

	var direction = (b - a).normalized()
	var perpendicular = direction.orthogonal() * o * 0.5

	var p1 = a + perpendicular
	var p2 = a - perpendicular
	var p3 = b - perpendicular
	var p4 = b + perpendicular
	var polygon := [p1, p2, p3, p4]
	$Line_Area/Collision.polygon = polygon
	$Line_Area.process_mode = Node.PROCESS_MODE_INHERIT
		
func _on_destroyed():
	queue_free()
	if prev_segment != null:
		prev_segment._on_destroyed()
		#$Broke.play()

func _process(delta: float) -> void:
	_draw_line()
