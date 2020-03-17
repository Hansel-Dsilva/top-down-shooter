extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		gui_menu()

func gui_menu():
	var new_pause_state: bool = not get_tree().paused
	get_tree().paused = not get_tree().paused
	visible = new_pause_state


func _on_Button_pressed():
	gui_menu()
