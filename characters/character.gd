extends KinematicBody2D
class_name Character
"""
Base character class. Gives node base variables and signals
"""



#Base player variables and stats
#export (int) var speed = 200
#var velocity: Vector2 = Vector2()
export var ACCELERATION = 9999999999
var motion := Vector2.ZERO
const FRICTION = 4000
