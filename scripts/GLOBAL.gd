extends Node

signal died

onready var player_gun = get_node("/root/Main/Player/Torso/Gun")

onready var debug_text = get_node("/root/Main/Player/CanvasLayer/Debug").text
