extends CenterContainer

func _on_start_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
