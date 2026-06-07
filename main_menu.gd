extends Control

@onready var bg = $Background
@onready var play_button = $PlayButton
@onready var stats_button = $StatsButton
@onready var quit_button = $QuitButton
@onready var stats_panel = $StatsPanel
@onready var total_play_time_label = $StatsPanel/TotalPlayTimeLabel/ValueLabel
@onready var total_runs_label = $StatsPanel/TotalRunsLabel/ValueLabel
@onready var total_kills_label = $StatsPanel/KillsLabel/TotalValueLabel
@onready var best_kills_label = $StatsPanel/KillsLabel/BestValueLabel
@onready var total_rooms_cleared_label = $StatsPanel/RoomsClearedLabel/TotalValueLabel
@onready var best_rooms_cleared_label = $StatsPanel/RoomsClearedLabel/BestValueLabel
@onready var total_floors_cleared_label = $StatsPanel/FloorsClearedLabel/TotalValueLabel
@onready var best_floors_cleared_label = $StatsPanel/FloorsClearedLabel/BestValueLabel
@onready var total_items_used_label = $StatsPanel/ItemsUsedLabel/TotalValueLabel
@onready var best_items_used_label = $StatsPanel/ItemsUsedLabel/BestValueLabel

func _ready() -> void:
    visible = true

    if Game.is_tutorial_complete:
        fade_out()

func _on_play_button_pressed() -> void:
    play_button.disabled = true
    stats_button.disabled = true
    quit_button.disabled = true

    Game.hud.click_sfx_player.play()

    if not Game.is_tutorial_complete:
        fade_out()

    var tween = create_tween()

    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)

    tween.finished.connect(play)

func _on_stats_button_pressed() -> void:
    play_button.disabled = true
    stats_button.disabled = true
    quit_button.disabled = true

    total_play_time_label.text = "%02d:%02d.%03d" % format_time(Game.total_play_time)
    total_runs_label.text = str(Game.total_runs)
    total_kills_label.text = str(Game.total_kills)
    best_kills_label.text = str(Game.best_kills)
    total_rooms_cleared_label.text = str(Game.total_rooms_cleared)
    best_rooms_cleared_label.text = str(Game.best_rooms_cleared)
    total_floors_cleared_label.text = str(Game.total_floors_cleared)
    best_floors_cleared_label.text = str(Game.best_floors_cleared)
    total_items_used_label.text = str(Game.total_items_used)
    best_items_used_label.text = str(Game.best_items_used)

    Game.hud.click_sfx_player.play()

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(stats_panel, "global_position", Vector2(320.0, 118.0), 1.0)

func _on_erase_save_data_button_pressed() -> void:
    Game.erase_save_data()

    total_play_time_label.text = "--:--.---"
    total_runs_label.text = "-"
    total_kills_label.text = "-"
    best_kills_label.text = "-"
    total_rooms_cleared_label.text = "-"
    best_rooms_cleared_label.text = "-"
    total_floors_cleared_label.text = "-"
    best_floors_cleared_label.text = "-"

    Game.reload_world()
    Game.reload_player()

func _on_close_stats_button_pressed() -> void:
    play_button.disabled = false
    stats_button.disabled = false
    quit_button.disabled = false

    Game.hud.click_sfx_player.play()

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(stats_panel, "global_position", Vector2(320.0, -844.0), 1.0)

func _on_quit_button_pressed() -> void:
    Game.save_progress()

    Game.hud.click_sfx_player.play()

    get_tree().quit()

func _on_meta_clicked(meta: Variant) -> void:
    OS.shell_open(meta)

func format_time(t: float) -> Array:
    var total_ms = int(round(t * 1000))
    var minutes = total_ms / 60000
    var seconds = (total_ms / 1000) % 60
    var milliseconds = total_ms % 1000

    return [int(minutes), int(seconds), int(milliseconds)]

func fade_out() -> void:
    var tween = create_tween()

    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(bg, "color", Color("#21212100"), 4.0)

    await tween.finished

    bg.queue_free()

func play() -> void:
    Game.total_runs += 1
    Game.player.can_play = true
    Game.player.timer_enabled = true

    get_parent().get_node("MouseCursor").region_rect = Rect2(32.0, 0.0, 32.0, 32.0)

    Game.hud.main.visible = true

    queue_free()
