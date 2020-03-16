extends Node

signal health_changed
signal start_respawn

var health: int = 100

func _ready() -> void:
	emit_signal("health_changed")


func health_check(change: int) -> void:
	health -= change
	emit_signal("health_changed")
	if self.health <= 0:
		print('DED')
		emit_signal("start_respawn")
		self.get_parent().queue_free()
