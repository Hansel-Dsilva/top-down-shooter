extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
#onready var character = $Enemies/Enemy2
#onready var Player = preload("res://characters/player/player.tscn")

#spawning enemies
onready var Enemy = preload('res://characters/enemy/enemy.tscn')
onready var Zom1 = preload('res://characters/zombie/zombie1.tscn')
export var spawn_no := 5
onready var all_tiles = $Navigation2D/TileMap.get_used_cells()
onready var tilemap = $Navigation2D/TileMap

#gui_menu
onready var gui_kills: String = $Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text

func _ready():
# warning-ignore:return_value_discarded
	GLOBAL.connect("died", self, "on_player_died")
	GLOBAL.connect("died", $Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer/HealthCounter, "_on_health_changed")
	GLOBAL.connect("died", $Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer/AmmoCounter, "_on_Gun_ammo_changed")
	$CanvasLayer/PauseMenu.gui_menu(false)
	for _i in range(spawn_no):
#		spawn_an_ene()
		spawn_a_zom()

func path_finder(enemy, player_last_pos):
	var new_path = nav_2d.get_simple_path(enemy.global_position, player_last_pos, false)
#	line_2d.points = new_path
	enemy.path = new_path
	
func _on_spawn_timer_timeout():
#	spawn_an_ene()
	spawn_a_zom()

func ene_died():
	$Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text = str(int($Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text) + 1)
	$CanvasLayer/PauseMenu.score = $Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text
	var timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", self, "_on_spawn_timer_timeout") 
	#timeout is what says in docs, in GLOBAL
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timer) #to process
	timer.start(10) #to start
	#assuming enemies only died from player
#	$Player.locked_target = null

func on_player_died():
	$Player/CanvasLayer/GUI/VBoxContainer/HBoxContainer2/KillCounter/Counter/Panel/Amount.text = '0'
	$CanvasLayer/PauseMenu.gui_menu(true)
	$Player.global_position = Vector2(37.479, 264.158)
	$Player/Health.health = 100
	$Player/Gun/Inventory.gun_ammo[2] = 0

func spawn_an_ene():
	randomize()
	var enemy = Enemy.instance()
	add_child(enemy)
	enemy.global_position = tilemap.map_to_world(all_tiles[randi() % (all_tiles.size()-100) + 100])
	enemy.global_position.x += 32
	enemy.global_position.y += 32
	enemy.connect("player_spot", self, "path_finder")
	enemy.get_node("Health").connect("start_respawn", self, "ene_died")
	enemy.connect("aim_locked", $Player, "_on_aim_locked")

func spawn_a_zom():
	randomize()
	var z1 = Zom1.instance()
	add_child(z1)
	z1.global_position = tilemap.map_to_world(all_tiles[randi() % (all_tiles.size()-100) + 100])
	z1.global_position.x += 32
	z1.global_position.y += 32
	z1.connect("player_spot", self, "path_finder")
	z1.get_node("Health").connect("start_respawn", self, "ene_died")
	z1.connect("aim_locked", $Player, "_on_aim_locked")
