extends Node2D
class_name WebManager
const WEB_SCENE := preload("res://Scenes/web.tscn")

var head_web : Web
var Head_Web : Web:
	set(value):
		if value != null:
			head_web = value
			head_web._toggle_end(true)
			
func _ready():
	$Check.process_mode = Node.PROCESS_MODE_DISABLED

func _create_segment(end_node : Vector2):
	var web_instance = WEB_SCENE.instantiate()
	var new_start = end_node if head_web == null else head_web.end_node
	web_instance._set_nodes(new_start, end_node)
	if head_web != null:
		head_web.make_collision_from_line()
		web_instance.prev_segment = head_web if head_web != null else null
	Head_Web = web_instance
	add_child(web_instance)
	
func _close_loop(posted : Web):
	var closed : bool = false
	var to_check : Web = head_web
	var segments : Array[Web]
	
	while !closed:
		closed = to_check.check_prev(posted)
		segments.append(to_check)
		to_check = to_check.prev_segment
	if posted.prev_segment != null:
		Head_Web = posted.prev_segment
	_call_close_behavior(segments.duplicate())
	for segment in segments:
		segment.queue_free()
		
func _call_close_behavior(segments : Array[Web]):
	$Check.process_mode = Node.PROCESS_MODE_INHERIT
	$Check._update_points(segments)
	
	
