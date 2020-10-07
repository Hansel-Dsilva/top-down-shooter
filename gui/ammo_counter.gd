extends HBoxContainer

var path_to_my_node: NodePath
onready var gun = GLOBAL.player_gun

#func _ready():
#	player = $GLOBAL.player

func _on_Gun_ammo_changed() -> void:
#	print("you changed bro")
	$"Counter/Panel/Amount".text = str(gun.get_node("Inventory").gun_ammo[gun.current_gun])
