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
	if self.health <= 0:
		self.get_parent().queue_free()
		if self == enemy:
			emit_signal("start_respawn")
		else:
			Signals.emit_signal("died")
