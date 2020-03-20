extends Character

var MAX_SPEED = 300
var path : = PoolVector2Array() setget set_path
#var Bullet = preload("res://weapons/bullet/bullet.tscn")
export var bullet_speed: int = 1500
var damage: int = 34

export (int) var detect_radius  # size of the visibility circle
export (float) var fire_rate  # delay time (s) between bullets
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)

var target  # player inside detection circle
var can_shoot = false
var result

#hansel basic AI
var velocity = Vector2()
signal player_spot(Character, lastLoc)
var player_last_pos
var los = false #can see the player

#gun sound
#var gun_sound: String = "res://weapons/gun/smg/smg_shot_" + str(randi() % 5 + 1) + ".wav"

signal aim_locked


func _process(delta):
	update()
	# if there's a target, rotate towards it and fire
	if target:
		aim()
		
	#non-path chase
	if target and los and abs((target.global_position - global_position).length()) > 100:
		velocity = position.direction_to(target.position) * MAX_SPEED
#		look_at(target.global_position)
		if position.distance_to(target.global_position) > 200:
			velocity = move_and_slide(velocity)
			player_last_pos = target.global_position
	#path to last seen pos
	elif not los and player_last_pos and abs((position - player_last_pos).length()) > 1:
#		target = null
		los = false
		emit_signal("player_spot", self, player_last_pos)
#		player_last_pos = null
#		var path_dist = 0
#		for i in range(path.size()-1):
#			path_dist += abs((path[i] - path[i+1]).length())
#		if path_dist > 100:
#			if result:
		var move_distance = MAX_SPEED * delta
		move_along_path(move_distance)

# warning-ignore:unused_argument
func shoot():
	#Bullet scene is loading into game
	var new_bullet = Bullet.instance()
	self.add_child(new_bullet)
	#Bullet position and rotation is set to the spawn point and rotation on the player
	new_bullet.position = $"BulletSpawn".global_position
	new_bullet.rotation = self.rotation
	#Velocity of the bullet is set to the speed of the weapon's bullets
	new_bullet.linear_velocity = Vector2(cos(rotation)*bullet_speed, sin(rotation)*bullet_speed)
	can_shoot = false
	$ShootTimer.start()

func _draw():
	# display the visibility area
#	draw_circle(Vector2(), detect_radius, vis_color)
	return

func _on_ShootTimer_timeout():
	can_shoot = true

func _ready() -> void:
	#Initial state: [idle]
#	set_process(false)
	# set the collision area's radius
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$visibility/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate
	
	$Health.connect("health_changed", self, "ene_hurt")
	#gun sound
#	$"GunSoundPlayer".stream = load(gun_sound)
	
#func _process(delta: float) -> void:
#	pass
#	#non-path chase
#	if target and los and abs((target.global_position - global_position).length()) > 100:
#		velocity = position.direction_to(target.position) * MAX_SPEED
##		look_at(target.global_position)
#		if position.distance_to(target.global_position) > 200:
#			velocity = move_and_slide(velocity)
#			player_last_pos = target.global_position
#
#	#path to last seen pos
#	elif player_last_pos and abs((position - player_last_pos).length()) > 1:
#		emit_signal("player_spot", self, player_last_pos)
##		var path_dist = 0
##		for i in range(path.size()-1):
##			path_dist += abs((path[i] - path[i+1]).length())
##		if path_dist > 100:
##			if result:
#		var move_distance = MAX_SPEED * delta
#		move_along_path(move_distance)

func move_along_path(distance : float):
	var start_point : = position
	for _i in range(path.size()):
		var distance_to_next : = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			look_at(path[0])
			if distance_to_next:
				var next_posn = start_point.linear_interpolate(path[0], distance / distance_to_next)
# warning-ignore:return_value_discarded
				move_and_collide(next_posn - global_position)
			break
		elif distance < 0.0:
			position = path[0]
			player_last_pos = null
			set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value : PoolVector2Array):
	path = value
#	if value.size() == 0:
#		set_process(false)
	
func _on_visibility_body_entered(body):
	# connect this to the "body_entered" signal
	if target:
		return
	if body.get_path() == "/root/Main/Player":
#		print(body.get_path())
		target = body
#		los = true
		set_process(true)

func _on_visibility_body_exited(body):
	# connect this to the "body_exited" signal
	if body.get_path() == "/root/Main/Player" and body == target:
			target = null
			los = false
			set_process(false)


func aim():
#	var hit_pos = []
	var space_state = get_world_2d().direct_space_state
#	var target_extents = target.get_node("Area2D/CollisionShape2D").shape.extents - Vector2(5, 5)
#	var nw = target.position - target_extents
#	var se = target.position + target_extents
#	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
#	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
#	for pos in [target.position, nw, ne, se, sw]:
	result = space_state.intersect_ray($BulletSpawn.global_position, target.position, [self], 3)
	if result:
#		hit_pos.append(result.position)
		if result.collider.name == "Player":
#				$Sprite.self_modulate.r = 1.0
			los = true
			rotation = (target.position - position).angle()
			if can_shoot:
				shoot()
				#gun sounds
				$"GunSoundPlayer".play(0)
		else:
			los = false

func _on_Respawn_timeout():
	print("Respawn Now")


func _on_Aim_Lock_pressed():
	emit_signal("aim_locked", self)

func ene_hurt():
	$ShootTimer.start(1)
	var hlth = $Health.health
	var health_color = float($Health.health) / 100
	$EnemySprite.modulate = Color( 1, health_color, health_color, 1 )
