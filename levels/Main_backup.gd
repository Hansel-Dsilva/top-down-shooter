extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
#onready var character = $Enemies/Enemy2
onready var player = $Player
var i

func _process(delta):
	var enemies = $Enemies.get_children()
	if enemies.size():
		for i in enemies:
			var new_path = nav_2d.get_simple_path(i.global_position, player.global_position)
			line_2d.points = new_path
			i.path = new_path


#func _on_Enemy2_tree_exiting():
#	set_process(false) # Replace with function body.
