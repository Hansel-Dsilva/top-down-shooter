extends Player

puppet var puppet_pos: Vector2 = Vector2()
puppet var puppet_velocity: Vector2 = Vector2()
puppet var puppet_rotation: float = 0

func make_gui() -> void:
	if is_network_master():
		$"Camera2D".make_current()
		$"CanvasLayer/GUI".visible = true


func _process(delta):
	#Create controlable Vector2 for player movement input
#	var velocity = Vector2()
	if is_network_master():
		#Change movement Vector2 variables on player input
		self.look_at(get_global_mouse_position())
		var axis = get_input_axis()
		if axis == Vector2.ZERO:
			apply_friction(ACCELERATION * delta)
		else:
			apply_movement(axis * ACCELERATION * delta)
			motion = move_and_slide(motion)
		
		rset("puppet_velocity", motion)
		rset("puppet_pos", position)
		rset("puppet_rotation", rotation)
	else:
		position = puppet_pos
		motion = puppet_velocity
		self.rotation = puppet_rotation
		puppet_pos = position # To avoid jitter
	
	
func set_player_name(new_name) -> void:
	get_node("CanvasLayer/Label").set_text(new_name)
