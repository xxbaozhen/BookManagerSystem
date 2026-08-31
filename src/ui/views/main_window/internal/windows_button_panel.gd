extends MarginContainer

func _on_minimize_button_pressed() -> void:
	get_window().set_mode(Window.MODE_MINIMIZED)

func _on_close_button_pressed() -> void:
	get_tree().quit()
