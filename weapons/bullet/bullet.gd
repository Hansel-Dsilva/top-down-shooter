extends RigidBody2D

onready var parent = self.get_parent().get_parent()

func _ready() -> void:
	set_as_toplevel(true)


#Check the collision of the bullet with objects
func _on_bullet_body_entered(body: PhysicsBody2D) -> void:
	print(body.collision_layer)
	match body.collision_layer:
		#Player collision layer
		16:
			if self.parent != body:
				if parent.has_node("Gun"):
					body.get_node("Health").health_check(parent.get_node("Gun").damage)
				else:
					body.get_node("Health").health_check(2)

				print(body.get_node("Health").health)
				self.queue_free()
		#Enemy collision
		1:
			if self.parent != body:
				body.get_node("Health").health_check(2)
				print(body.get_node("Health").health)
				self.queue_free()
		#Wall collision layer
		2:
			self.queue_free()
			print("nice wall")


#Delete bullet after timer runs out
func _on_Timer_timeout() -> void:
	self.queue_free()
