extends Control

@onready var panel = $Panel

func _process(_delta: float) -> void:
	if Game.player.can_play:
		if Input.is_action_just_pressed("toggle_pause"):
			if get_tree().paused:
				hide_menu()
			else:
				show_menu()

func _on_resume_button_pressed() -> void:
	hide_menu()

func _on_quit_button_pressed() -> void:
	Game.hud.click_sfx_player.play()
	
	get_tree().quit()

func show_menu() -> void:
	get_tree().paused = true
	
	Game.hud.click_sfx_player.play()
	
	get_parent().get_node("MouseCursor").region_rect = Rect2(0.0, 0.0, 32.0, 32.0)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(panel, "global_position", Vector2(720.0, 270.0), 1.0)

func hide_menu() -> void:
	get_tree().paused = false
	
	Game.hud.click_sfx_player.play()
	
	get_parent().get_node("MouseCursor").region_rect = Rect2(32.0, 0.0, 32.0, 32.0)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(panel, "global_position", Vector2(720.0, -540.0), 1.0)
