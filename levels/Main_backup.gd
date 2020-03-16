extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
#onready var character = $Enemies/Enemy2
#onready var player = $Player
#var i
#var enemy
#var player_last_pos

#hansel threading
var thread
#spawning enemies
onready var Enemy = preload('res://characters/enemy/enemy.tscn')
export var spawn_no := 5
onready var all_tiles = $Navigation2D/TileMap.get_used_cells()
onready var tilemap = $Navigation2D/TileMap

func _ready():
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
	var timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", self, "_on_spawn_timer_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timer) #to process
	timer.start(10) #to start

func _process(_delta):
	pass
