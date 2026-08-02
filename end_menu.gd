extends Control

@onready var panel = $Panel
@onready var title_label = $Panel/TitleLabel
@onready var time_label = $Panel/StatsContainer/TimeLabel
@onready var score_label = $Panel/StatsContainer/ScoreLabel
@onready var kills_label = $Panel/StatsContainer/KillsLabel
@onready var rooms_cleared_label = $Panel/StatsContainer/RoomsClearedLabel
@onready var floors_cleared_label = $Panel/StatsContainer/FloorsClearedLabel
@onready var items_used_label = $Panel/StatsContainer/ItemsUsedLabel
@onready var time_value_label = $Panel/StatsValuesContainer/TimeLabel
@onready var score_value_label = $Panel/StatsValuesContainer/ScoreLabel
@onready var kills_value_label = $Panel/StatsValuesContainer/KillsLabel
@onready var rooms_cleared_value_label = $Panel/StatsValuesContainer/RoomsClearedLabel
@onready var floors_cleared_value_label = $Panel/StatsValuesContainer/FloorsClearedLabel
@onready var items_used_value_label = $Panel/StatsValuesContainer/ItemsUsedLabel
@onready var message_label = $Panel/MessageLabel
@onready var quit_button = $Panel/QuitButton
@onready var to_main_menu_button = $Panel/ToMainMenuButton
@onready var try_again_button = $Panel/TryAgainButton
@onready var next_floor_button = $Panel/NextFloorButton
@onready var win_sfx_player = $WinSFXPlayer
@onready var lose_sfx_player = $LoseSFXPlayer

var messages_on_lose = [
    "Don't die please",
    "Pro tip: Lock in",
    "Pro tip: Do what is necessary; don't do what isn't necessary",
    "Try harder",
    "Explosions hurt",
    "Epic fail",
    "That was close though",
    "You shouldn't give up yet",
    "Did you know that turning on the monitor can improve your gameplay?",
	"Skill issue"
]

var messages_on_win = [
    "Keep going",
    "Chill",
    "Pro tip: Try entering more rooms to kill even more Shapes",
    "Accuracy is key",
    "Pro tip: Pentagons deal damage to other enemies too",
    "The party is proud of you",
    "GG EZ",
    "You were extra violent this time",
    "Holy shit!",
	"Wait, is this WR?!"
]

func _on_quit_button_pressed() -> void:
    Game.hud.click_sfx_player.play()

    get_tree().quit()

func _on_to_main_menu_button_pressed() -> void:
    Game.hud.click_sfx_player.play()

    Game.reload_world()
    Game.reload_player()

    Game.player.revive()

    Game.console.cmd_disable_cheats(PackedStringArray([]))

    Game.player.damage_multi = 1.0
    Game.player.speed_multi = 1.0
    Game.player.projectile_speed_multi = 1.0
    Game.player.points_multi = 1

    Game.player.run_time = 0.0
    Game.player.run_score = 0
    Game.player.run_points = 0
    Game.player.run_points_earned = 0
    Game.player.run_points_spent = 0
    Game.player.run_kills = 0
    Game.player.run_rooms_cleared = 0
    Game.player.run_floors_cleared = 0

    Game.player.current_floor = 1

    hide_menu()

    get_tree().reload_current_scene()

func _on_try_again_button_pressed() -> void:
    Game.hud.click_sfx_player.play()

    Game.reload_world()
    Game.reload_player()

    Game.player.revive()

    Game.console.cmd_disable_cheats(PackedStringArray([]))

    Game.player.damage_multi = 1.0
    Game.player.speed_multi = 1.0
    Game.player.projectile_speed_multi = 1.0
    Game.player.points_multi = 1

    Game.player.run_time = 0.0
    Game.player.run_score = 0
    Game.player.run_points = 0
    Game.player.run_points_earned = 0
    Game.player.run_points_spent = 0
    Game.player.run_kills = 0
    Game.player.run_rooms_cleared = 0
    Game.player.run_floors_cleared = 0

    Game.player.current_floor = 1

    hide_menu()

func _on_next_floor_button_pressed() -> void:
    Game.hud.click_sfx_player.play()

    Game.reload_world()
    Game.reload_player()

    Game.player.current_floor += 1

    hide_menu()

func show_menu() -> void:
    Game.player.can_play = false
    Game.player.timer_enabled = false

    if Game.player.fsm.state == Game.player.fsm.states.DEAD:
        Game.player.is_wizard_killed = false

        lose_sfx_player.play()

        title_label.text = "YOU DIED. RUN RESULTS:"

        time_label.visible = true
        score_label.visible = true
        kills_label.visible = true
        rooms_cleared_label.visible = true
        floors_cleared_label.visible = true
        items_used_label.visible = true
        time_value_label.visible = true
        score_value_label.visible = true
        kills_value_label.visible = true
        rooms_cleared_value_label.visible = true
        floors_cleared_value_label.visible = true
        items_used_value_label.visible = true

        time_value_label.text = "%02d:%02d.%03d" % format_time(Game.player.run_time)
        score_value_label.text = str(Game.player.run_score)
        kills_value_label.text = str(Game.player.run_kills)
        rooms_cleared_value_label.text = str(Game.player.run_rooms_cleared)
        floors_cleared_value_label.text = str(Game.player.run_floors_cleared)
        items_used_value_label.text = str(Game.player.run_items_used)

        message_label.text = "[wobble]%s[/wobble]" % messages_on_lose.pick_random()

        try_again_button.visible = true
        next_floor_button.visible = false
    else:
        win_sfx_player.play()

        if not Game.player.cheats_enabled:
            Game.data["total_points_earned"] += 1 * Game.player.points_multi
            Game.data["total_floors_cleared"] += 1

        Game.player.run_floors_cleared += 1

        Game.player.run_score += 10
        Game.player.run_points += 1 * Game.player.points_multi
        Game.player.run_points_earned += 1 * Game.player.points_multi

        title_label.text = "FLOOR #%s RESULTS:" % Game.player.current_floor

        time_label.visible = true
        score_label.visible = false
        kills_label.visible = true
        rooms_cleared_label.visible = true
        floors_cleared_label.visible = false
        items_used_label.visible = true
        time_value_label.visible = true
        score_value_label.visible = false
        kills_value_label.visible = true
        rooms_cleared_value_label.visible = true
        floors_cleared_value_label.visible = false
        items_used_value_label.visible = true

        time_value_label.text = "%02d:%02d.%03d" % format_time(Game.player.floor_time)
        score_value_label.text = str(Game.player.run_score)
        kills_value_label.text = str(Game.player.floor_kills)
        rooms_cleared_value_label.text = str(Game.player.floor_rooms_cleared)
        floors_cleared_value_label.text = str(Game.player.run_floors_cleared)
        items_used_value_label.text = str(Game.player.floor_items_used)

        if not Game.data["is_tutorial_complete"]:
            Game.data["is_tutorial_complete"] = true

            Game.player.health = Game.player.max_health

            time_label.visible = true
            score_label.visible = true
            kills_label.visible = true
            rooms_cleared_label.visible = false
            floors_cleared_label.visible = false
            items_used_label.visible = true
            time_value_label.visible = true
            score_value_label.visible = true
            kills_value_label.visible = true
            rooms_cleared_value_label.visible = false
            floors_cleared_value_label.visible = false
            items_used_value_label.visible = true

            title_label.text = "TUTORIAL RESULTS:"

            message_label.text = "[wobble]First time, huh? Good luck, you are on route to the real stuff[/wobble]"
        else:
            message_label.text = "[wobble]%s[/wobble]" % messages_on_win.pick_random()

        try_again_button.visible = false
        next_floor_button.visible = true

    Game.hud.main.visible = false

    Game.hud.trade_menu.load_menu_items()

    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

    quit_button.disabled = true
    to_main_menu_button.disabled = true
    try_again_button.disabled = true
    next_floor_button.disabled = true

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(panel, "global_position", Vector2(320.0, 124.0), 1.0)

    if not Game.player.cheats_enabled:
        Game.save_progress()

    await tween.finished

    quit_button.disabled = false
    to_main_menu_button.disabled = false
    try_again_button.disabled = false
    next_floor_button.disabled = false

    Game.player.velocity = Vector2.ZERO
    Game.player.direction = Vector2.ZERO

func hide_menu() -> void:
    quit_button.disabled = true
    to_main_menu_button.disabled = true
    try_again_button.disabled = true
    next_floor_button.disabled = true

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(panel, "global_position", Vector2(320.0, -832.0), 1.0)

    tween.finished.connect(play)

func format_time(t: float) -> Array:
    var total_ms = round(t * 1000)
    var minutes = total_ms / 60000
    var seconds = int(total_ms / 1000) % 60
    var milliseconds = int(total_ms) % 1000

    return [int(minutes), int(seconds), int(milliseconds)]

func play() -> void:
    Game.player.can_play = true
    Game.player.timer_enabled = true

    Game.player.velocity = Vector2.ZERO
    Game.player.direction = Vector2.ZERO

    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

    Game.hud.main.visible = true
