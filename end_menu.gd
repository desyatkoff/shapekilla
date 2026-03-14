extends Control

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func show_menu() -> void:
	visible = true
	
	get_tree().current_scene.get_node("Player").can_play = false
	get_parent().get_node("MouseCursor").region_rect = Rect2(0.0, 0.0, 32.0, 32.0)
