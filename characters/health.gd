extends Node

signal health_changed
signal start_respawn

var health: int = 100

var enemy = load('res://characters/enemy/enemy.tscn')

func _ready() -> void:
	emit_signal("health_changed")

func health_check(change: int) -> void:
	health -= change
	emit_signal("health_changed")
	var par = get_parent()
	if self.health <= 0:
		#if not player
		if not get_parent().get_node_or_null("Gun"):
			self.get_parent().queue_free()
			emit_signal("start_respawn")
		else:
			GLOBAL.emit_signal("died")
