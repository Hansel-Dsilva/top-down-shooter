extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
#onready var character = $Enemies/Enemy2
#onready var Player = preload("res://characters/player/player.tscn")

#spawning enemies
onready var Enemy = preload('res://characters/enemy/enemy.tscn')
export var spawn_no := 5
onready var all_tiles = $Navigation2D/TileMap.get_used_cells()
onready var tilemap = $Navigation2D/TileMap

#gui_menu
onready var gui_kills: String = $Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text

func _ready():
# warning-ignore:return_value_discarded
	Signals.connect("died", self, "on_player_died")
	$CanvasLayer/PauseMenu.gui_menu(false)
	for _i in range(spawn_no):
		randomize()
		var enemy = Enemy.instance()
		add_child(enemy)
		enemy.global_position = tilemap.map_to_world(all_tiles[randi() % (all_tiles.size()-100) + 100])
		enemy.global_position.x += 32
		enemy.global_position.y += 32
		enemy.connect("player_spot", self, "path_finder")
		enemy.get_node("Health").connect("start_respawn", self, "ene_died")

func path_finder(enemy, player_last_pos):
	var new_path = nav_2d.get_simple_path(enemy.global_position, player_last_pos, false)
	line_2d.points = new_path
	enemy.path = new_path
	
func _on_spawn_timer_timeout():
	randomize()
	var enemy = Enemy.instance()
	add_child(enemy)
	enemy.global_position = tilemap.map_to_world(all_tiles[randi() % (all_tiles.size()-10) + 10])
	enemy.connect("player_spot", self, "path_finder")
	enemy.get_node("Health").connect("start_respawn", self, "ene_died")

func ene_died():
	$Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text = str(int($Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text) + 1)
	$CanvasLayer/PauseMenu.score = $Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text
	var timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", self, "_on_spawn_timer_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timer) #to process
	timer.start(10) #to start

func on_player_died():
	$Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text = '0'
	$CanvasLayer/PauseMenu.gui_menu(true)
	$Player.global_position = Vector2(37.479, 264.158)
	$Player/Health.health = 100
