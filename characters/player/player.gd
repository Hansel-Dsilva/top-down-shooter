extends Character
class_name Player
"""
Base player class. Gives the player the ability to move
"""
export var MAX_SPEED = 500
var move_dir = Vector2.ZERO

func _ready() -> void:
	make_gui()


func make_gui() -> void:
	$"Camera2D".make_current()
	$"CanvasLayer/GUI".visible = true


func _process(delta: float) -> void:
	get_input(delta)
	#debug
#	$CanvasLayer/Debug.text = "Moving: " + str(get_input_move_dir().angle())
#	$Torso.speed_scale = motion.length()/500
	$Legs.speed_scale =  motion.length()/500
	if move_dir:
		$Legs.global_rotation = get_input_move_dir().angle()
	if not motion.length():
		$Legs.frame = 0
	
func get_input(delta: float) -> void:
#	get_input()\
	get_tree().set_input_as_handled()
	self.look_at(get_global_mouse_position())
	move_dir = get_input_move_dir()
	if move_dir == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(move_dir * ACCELERATION * delta)
	motion = move_and_slide(motion)
	
func get_input_move_dir():
	move_dir.x = int(Input.is_action_pressed("player_move_right")) - int(Input.is_action_pressed("player_move_left"))
	move_dir.y = int(Input.is_action_pressed("player_move_down")) - int(Input.is_action_pressed("player_move_up"))
	return move_dir.normalized()
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
#Hansel
	
func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.has_method("gun_pickup"):
		$Torso.animation = "uzi"
	
func _on_Torso_animation_finished():
	pass
#	$Torso.stop()
#	$Torso.frame = 0
