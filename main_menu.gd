extends Control

@onready var bg = $Background

@onready var play_button = $VBoxContainer/PlayButton
@onready var settings_button = $VBoxContainer/SettingsButton
@onready var stats_button = $VBoxContainer/StatsButton
@onready var quit_button = $VBoxContainer/QuitButton

@onready var settings_panel = $SettingsPanel
@onready var max_fps_hslider = $SettingsPanel/SettingsValuesContainer/MaxFPS/MaxFPSHSlider
@onready var max_fps_label = $SettingsPanel/SettingsValuesContainer/MaxFPS/MaxFPSLabel
@onready var fullscreen_check_box = $SettingsPanel/SettingsValuesContainer/FullscreenCheckBox
@onready var v_sync_check_box = $SettingsPanel/SettingsValuesContainer/VSyncCheckBox
@onready var audio_volume_hslider = $SettingsPanel/SettingsValuesContainer/AudioVolume/AudioVolumeHSlider
@onready var audio_volume_label = $SettingsPanel/SettingsValuesContainer/AudioVolume/AudioVolumeLabel

@onready var stats_panel = $StatsPanel
@onready var total_play_time_label = $StatsPanel/StatsValuesContainer/TotalPlayTimeLabel
@onready var total_runs_label = $StatsPanel/StatsValuesContainer/TotalRunsLabel
@onready var high_score_label = $StatsPanel/StatsValuesContainer/HighScoreLabel
@onready var total_points_earned_label = $StatsPanel/StatsValuesContainer/PointsEarnedContainer/TotalPointsEarnedLabel
@onready var best_points_earned_label = $StatsPanel/StatsValuesContainer/PointsEarnedContainer/BestPointsEarnedLabel
@onready var total_points_spent_label = $StatsPanel/StatsValuesContainer/PointsSpentContainer/TotalPointsSpentLabel
@onready var best_points_spent_label = $StatsPanel/StatsValuesContainer/PointsSpentContainer/BestPointsSpentLabel
@onready var total_kills_label = $StatsPanel/StatsValuesContainer/KillsContainer/TotalKillsLabel
@onready var best_kills_label = $StatsPanel/StatsValuesContainer/KillsContainer/BestKillsLabel
@onready var total_rooms_cleared_label = $StatsPanel/StatsValuesContainer/RoomsClearedContainer/TotalRoomsClearedLabel
@onready var best_rooms_cleared_label = $StatsPanel/StatsValuesContainer/RoomsClearedContainer/BestRoomsClearedLabel
@onready var total_floors_cleared_label = $StatsPanel/StatsValuesContainer/FloorsClearedContainer/TotalFloorsClearedLabel
@onready var best_floors_cleared_label = $StatsPanel/StatsValuesContainer/FloorsClearedContainer/BestFloorsClearedLabel
@onready var total_items_used_label = $StatsPanel/StatsValuesContainer/ItemsUsedContainer/TotalItemsUsedLabel
@onready var best_items_used_label = $StatsPanel/StatsValuesContainer/ItemsUsedContainer/BestItemsUsedLabel

func _ready() -> void:
    visible = true

    if Game.data["is_tutorial_complete"]:
        fade_out()

func _on_play_button_pressed() -> void:
    play_button.disabled = true
    settings_button.disabled = true
    stats_button.disabled = true
    quit_button.disabled = true

    Game.hud.click_sfx_player.play()

    if not Game.data["is_tutorial_complete"]:
        fade_out()

    var tween = create_tween()

    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)

    tween.finished.connect(play)

func _on_settings_button_pressed() -> void:
    play_button.disabled = true
    settings_button.disabled = true
    stats_button.disabled = true
    quit_button.disabled = true

    update_settings_values()

    Game.hud.click_sfx_player.play()

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(settings_panel, "global_position", Vector2(512.0, 220.0), 1.0)

func _on_max_fps_hslider_value_changed(value: float) -> void:
    Game.set_max_fps(int(value))

    update_settings_values()

func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
    Game.set_fullscreen(toggled_on)

    update_settings_values()

func _on_v_sync_check_box_toggled(toggled_on: bool) -> void:
    Game.set_vsync(toggled_on)

    update_settings_values()

func _on_audio_volume_hslider_value_changed(value: float) -> void:
    Game.set_audio_volume(value)

    update_settings_values()

func _on_close_settings_button_pressed() -> void:
    play_button.disabled = false
    settings_button.disabled = false
    stats_button.disabled = false
    quit_button.disabled = false

    Game.hud.click_sfx_player.play()

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(settings_panel, "global_position", Vector2(512.0, -640.0), 1.0)

func _on_stats_button_pressed() -> void:
    play_button.disabled = true
    settings_button.disabled = true
    stats_button.disabled = true
    quit_button.disabled = true

    total_play_time_label.text = "%02d:%02d.%03d" % format_time(Game.data["total_play_time"])
    total_runs_label.text = str(Game.data["total_runs"])
    high_score_label.text = str(Game.data["high_score"])
    total_points_earned_label.text = str(Game.data["total_points_earned"])
    best_points_earned_label.text = str(Game.data["best_points_earned"])
    total_points_spent_label.text = str(Game.data["total_points_spent"])
    best_points_spent_label.text = str(Game.data["best_points_spent"])
    total_kills_label.text = str(Game.data["total_kills"])
    best_kills_label.text = str(Game.data["best_kills"])
    total_rooms_cleared_label.text = str(Game.data["total_rooms_cleared"])
    best_rooms_cleared_label.text = str(Game.data["best_rooms_cleared"])
    total_floors_cleared_label.text = str(Game.data["total_floors_cleared"])
    best_floors_cleared_label.text = str(Game.data["best_floors_cleared"])
    total_items_used_label.text = str(Game.data["total_items_used"])
    best_items_used_label.text = str(Game.data["best_items_used"])

    Game.hud.click_sfx_player.play()

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(stats_panel, "global_position", Vector2(320.0, 60.0), 1.0)

func _on_erase_save_data_button_pressed() -> void:
    Game.erase_save_data()

    total_play_time_label.text = "--:--.---"
    total_runs_label.text = "-"
    high_score_label.text = "-"
    total_points_earned_label.text = "-"
    best_points_earned_label.text = "-"
    total_points_spent_label.text = "-"
    best_points_spent_label.text = "-"
    total_kills_label.text = "-"
    best_kills_label.text = "-"
    total_rooms_cleared_label.text = "-"
    best_rooms_cleared_label.text = "-"
    total_floors_cleared_label.text = "-"
    best_floors_cleared_label.text = "-"
    total_items_used_label.text = "-"
    best_items_used_label.text = "-"

    Game.reload_world()
    Game.reload_player()

    get_tree().reload_current_scene()

func _on_close_stats_button_pressed() -> void:
    play_button.disabled = false
    settings_button.disabled = false
    stats_button.disabled = false
    quit_button.disabled = false

    Game.hud.click_sfx_player.play()

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(stats_panel, "global_position", Vector2(320.0, -960.0), 1.0)

func _on_quit_button_pressed() -> void:
    Game.save_progress()

    Game.hud.click_sfx_player.play()

    get_tree().quit()

func update_settings_values() -> void:
    max_fps_hslider.value = Game.settings["max_fps"]
    max_fps_label.text = ("%s FPS" % int(Game.settings["max_fps"])) if Game.settings["max_fps"] != 0 else "Unlimited"
    fullscreen_check_box.button_pressed = Game.settings["fullscreen"]
    v_sync_check_box.button_pressed = Game.settings["vsync"]
    audio_volume_hslider.value = Game.settings["audio_volume"]
    audio_volume_label.text = "%s%%" % int(Game.settings["audio_volume"])

func format_time(t: float) -> Array:
    var total_ms = round(t * 1000)
    var minutes = total_ms / 60000
    var seconds = int(total_ms / 1000) % 60
    var milliseconds = int(total_ms) % 1000

    return [int(minutes), int(seconds), int(milliseconds)]

func fade_out() -> void:
    var tween = create_tween()

    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(bg, "color", Color("#21212100"), 4.0)

    await tween.finished

    bg.queue_free()

func play() -> void:
    Game.data["total_runs"] += 1
    Game.player.can_play = true
    Game.player.timer_enabled = true

    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

    Game.hud.main.visible = true

    queue_free()
