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

func _on_to_main_menu_button_pressed() -> void:
    Game.reload_world()
    Game.reload_player()

    Game.player.revive()

    Game.player.cheats_enabled = false

    Game.player.run_time = 0.0
    Game.player.run_kills = 0
    Game.player.run_rooms_cleared = 0
    Game.player.run_floors_cleared = 0

    Game.player.current_floor = 1

    Game.player.is_wizard_killed = false
    Game.hud.trade_menu.load_menu_items()

    hide_menu()

    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

    get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
    if not Game.player.cheats_enabled:
        Game.save_progress()

    Game.hud.click_sfx_player.play()

    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

    get_tree().quit()

func show_menu() -> void:
    get_tree().paused = true

    Game.hud.click_sfx_player.play()

    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(panel, "global_position", Vector2(720.0, 270.0), 0.5)

func hide_menu() -> void:
    get_tree().paused = false

    Game.hud.click_sfx_player.play()

    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(panel, "global_position", Vector2(720.0, -540.0), 0.5)
