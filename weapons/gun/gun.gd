extends Node2D

const Bullet = preload("res://weapons/bullet/bullet.tscn")


signal gun_changed
signal ammo_changed

var current_gun: int = 0
var bullet_speed: int = 500
var damage: int = 34

#gun sound
#var gun_sound: String = "res://weapons/gun/smg/smg_shot_" + str(randi() % 5 + 1) + ".wav"

var new_bullet

func _ready() -> void:
	make_gui()
#	$"GunSoundPlayer".stream = load(gun_sound)
	$AutoFire.stop()


func _process(delta: float) -> void:
	check_shoot()
#	change_gun()


func make_gui() -> void:
	emit_signal("gun_changed")
	emit_signal("ammo_changed")

func _shoot() -> void:
	if $"Inventory".gun_ammo[current_gun] > 0:

		#Bullet scene is loading into game
		shoot_bullet()
#		var new_bullet = Bullet.instance()
#		self.add_child(new_bullet)
#		#Bullet position and rotation is set to the spawn point and rotation on the player
#		new_bullet.global_position = $"BulletSpawn".global_position
#		new_bullet.global_rotation = get_parent().global_rotation
#		#Velocity of the bullet is set to the speed of the weapon's bullets
#		new_bullet.linear_velocity = Vector2(cos(get_parent().rotation)*bullet_speed, sin(get_parent().rotation)*bullet_speed)
		
		#Play the sound for the current gun being used
		play_gun_sound()
#		var gun_sound: String
##		match current_gun:
##			#Pistol
##			0:
##				gun_sound = "res://weapons/gun/pistol/pistol_shot_" + str(randi() % 3 + 1) + ".wav"
##			#RPG
##			1:
##				gun_sound = "res://weapons/gun/rpg/rpg_shot_" + str(randi() % 3 + 1) + ".wav"
##			#SMG
##			2:
#		gun_sound = "res://weapons/gun/smg/smg_shot_" + str(randi() % 5 + 1) + ".wav"				
#		$"GunSoundPlayer".stream = load(gun_sound)
#		$"GunSoundPlayer".play(0)
		#Check to see if player still has ammo for all guns besides starting weapon
#		if current_gun > 0:

		$"Inventory".gun_ammo[current_gun] -= 1
#		print($"Inventory".gun_ammo[current_gun])
		emit_signal("ammo_changed")
#		print("one less")
		
		#Shoot animation
		get_parent().get_node("Torso").frame = 0	#Change to first frame ie shot fired
		get_parent().get_node("Torso").play("uzi")	#Slowly return to last frame ie not firing

func change_gun() -> void:
	#Switch player weapon when switch weapon key is pressed
	if Input.is_action_just_pressed("switch_weapon_1"):
		if $"Inventory".has_guns[0] == true:
			self.current_gun = 0
			self.bullet_speed = 500
			self.damage = 34
			#Send signal to GUI about gun change
			emit_signal("gun_changed")
			emit_signal("ammo_changed")
	if Input.is_action_just_pressed("switch_weapon_2"):
		if $"Inventory".has_guns[1] == true:
			self.current_gun = 1
			self.bullet_speed = 100
			self.damage = 100
			#Send signal to GUI about gun change
			emit_signal("gun_changed")
			emit_signal("ammo_changed")
	if Input.is_action_just_pressed("switch_weapon_3"):
		if $"Inventory".has_guns[2] == true:
			self.current_gun = 2
			self.bullet_speed = 10000
			self.damage = 50
			#Send signal to GUI about gun change
			emit_signal("gun_changed")
			emit_signal("ammo_changed")


func check_shoot() -> void:
	if Input.is_action_just_pressed("fire_gun"):
		get_tree().set_input_as_handled()
		self._shoot()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.has_method("gun_pickup"):
		self.current_gun = area.gun_number
		self.bullet_speed = area.bullet_speed
		self.damage = area.damage
#		v0.2
		$Inventory.gun_ammo[self.current_gun] += area.gun_ammo_count
#		$Inventory.gun_ammo[self.current_gun] = 100
		$Inventory.has_guns[current_gun] = true
		emit_signal("gun_changed")
		emit_signal("ammo_changed")

func ana_aim(ana_force, ana_obj):
	if ana_force and $AutoFire.is_stopped():
		$AutoFire.start()
	elif not ana_force and not $AutoFire.is_stopped():
		$AutoFire.stop()

func _on_AutoFire_timeout():
	_shoot()

func shoot_bullet():
	create_bullet()
#	var new_bullet = Bullet.instance()
#	self.add_child(new_bullet)
	#Bullet position and rotation is set to the spawn point and rotation on the player
	new_bullet.global_position = $"BulletSpawn".global_position
	new_bullet.global_rotation = get_parent().global_rotation
	#Velocity of the bullet is set to the speed of the weapon's bullets
	new_bullet.linear_velocity = Vector2(cos(get_parent().rotation)*bullet_speed, sin(get_parent().rotation)*bullet_speed)

func play_gun_sound():
#		var gun_sound: String
#		gun_sound = "res://weapons/gun/smg/smg_shot_" + str(randi() % 5 + 1) + ".wav"
#		$"GunSoundPlayer".stream = load(gun_sound)
		$"GunSoundPlayer".play(0)

func create_bullet():
	new_bullet = Bullet.instance()
	self.add_child(new_bullet)
