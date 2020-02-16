extends Character
class_name Player
"""
Base player class. Gives the player the ability to move
"""
var MAX_SPEED = 350

const gun1 = preload("res://graphics/assets/manBlue_gun.png")

func _ready() -> void:
	make_gui()


func make_gui() -> void:
	$"Camera2D".make_current()
	$"CanvasLayer/GUI".visible = true


func _process(delta: float) -> void:
	get_input(delta)

func get_input(delta: float) -> void:
#	get_input()
	self.look_at(get_global_mouse_position())
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)
	
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("player_move_right")) - int(Input.is_action_pressed("player_move_left"))
	axis.y = int(Input.is_action_pressed("player_move_down")) - int(Input.is_action_pressed("player_move_up"))
	return axis.normalized()
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
#Hansel
func change_sprite_textue():
	pass
	$Sprite.set_texture(gun1)
	$Sprite.position.x = 10.131
	
func _on_Area2D_area_entered(area: Area2D) -> void:
	change_sprite_textue()
	

