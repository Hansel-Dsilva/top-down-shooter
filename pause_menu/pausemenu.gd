extends Control

var score := 0
var dead

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		gui_menu(false)

# warning-ignore:shadowed_variable
func gui_menu(died):
	$you_died.visible = died
	dead = died
	$Score.text = "Your Score : " + str(score)
	var new_pause_state: bool = not get_tree().paused
	get_tree().paused = not get_tree().paused
	visible = new_pause_state

func _on_Button_pressed():
	if dead:
		score = 0
	gui_menu(false)
