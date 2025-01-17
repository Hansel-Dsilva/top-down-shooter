extends Character
class_name Player
"""
Base player class. Gives the player the ability to move
"""
export var MAX_SPEED = 300
var move_dir = Vector2.ZERO
var aim := Vector2()

func _ready() -> void:
	# Touch related. Add "TouchAnalogs" scene from "AndroidStuff" folder to Player scene, then uncomment next 3 lines
#	$CanvasLayer/Left/Analog.connect("analog_force_change", self, "ana_dir")
#	$CanvasLayer/Right/Analog.connect("analog_force_change", self, "ana_aim")
#	$CanvasLayer/Right/Analog.connect("analog_force_change", $Gun, "ana_aim")
	make_gui()
	
func make_gui() -> void:
	$"Camera2D".make_current()
	$"CanvasLayer/GUI".visible = true

func _physics_process(delta):
	get_input(delta)

func _process(delta: float) -> void:
#	GLOBAL.debug_text = str("global_rotation")
	print(global_rotation)
	look_at(get_global_mouse_position())
	get_input_move_dir()
	move_and_slide(move_dir * MAX_SPEED)
	
	$Legs.speed_scale =  motion.length()/500
	if move_dir:
		$Legs.global_rotation = move_dir.angle()
	if not motion.length():
		$Legs.frame = 0
	
func get_input(delta: float) -> void:
#	get_input()\
	get_tree().set_input_as_handled()
#	look_at(get_global_mouse_position())
	
#	move_dir = get_input_move_dir()
	if move_dir.length() < 0.00001:
#		apply_friction(ACCELERATION * delta)
		motion = motion.move_toward(Vector2.ZERO, FRICTION * delta)
	else:
#		apply_movement(move_dir * ACCELERATION * delta)
		motion = motion.move_toward(move_dir * MAX_SPEED, ACCELERATION * delta)
	motion = move_and_slide(motion)
	# aim direction
	if aim:
		rotation = aim.angle()
		$Camera2D.offset.y = move_toward($Camera2D.offset.y, aim.y*200, delta*600)
	elif move_dir:
#		rotation = move_dir.angle()
		$Camera2D.offset.y = move_toward($Camera2D.offset.y, motion.y/2, delta*motion.length_squared()/300)
	else:
		$Camera2D.offset = $Camera2D.offset.move_toward(Vector2.ZERO, delta * 200)
	
	#make camera look ahead
	$CanvasLayer/Debug.text = str(global_rotation)


func get_input_move_dir():
	move_dir.x = int(Input.is_action_pressed("player_move_right")) - int(Input.is_action_pressed("player_move_left"))
	move_dir.y = int(Input.is_action_pressed("player_move_down")) - int(Input.is_action_pressed("player_move_up"))
	move_dir = move_dir.normalized()
	
#func apply_friction(amount):
#	if motion.length() > amount:
#		motion -= motion.normalized() * amount
#	else:
#		motion = Vector2.ZERO
		
#func apply_movement(acceleration):
#	motion += acceleration
#	motion = motion.clamped(MAX_SPEED)
#Hansel
#	motion = motion.move_toward(move_dir * MAX_SPEED, ACCELERATION * delta)
	
#func ana_dir(ana_force, ana_obj):
#	move_dir = ana_force
#	move_dir.y *= -1


#func ana_aim(ana_force, ana_obj):
#	ana_force.y *= -1
#	aim = ana_force


func _on_Aread2D_area_enetered(_body):
	return
	
	
#func _on_aim_locked(locked_target):
#	self.locked_target = locked_target
