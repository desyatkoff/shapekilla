extends Control

@onready var logo = $Logo
@onready var loading_label = $LoadingLabel
@onready var progress_bar = $ProgressBar

var game_scene_path = "res://game.tscn"
var game_packed_scene: PackedScene

var loading_status = []
var loading_progress = 0.0

signal loaded_game

func _ready() -> void:
    ResourceLoader.load_threaded_request(game_scene_path)

    logo.modulate = Color.TRANSPARENT

    await create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(logo, "modulate", Color.WHITE, 1.0).finished

    await loaded_game

    create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(loading_label, "modulate", Color.TRANSPARENT, 1.5)
    create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).tween_property(logo, "size", Vector2(640, 512), 2.5)
    create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).tween_property(logo, "global_position", Vector2(640, -96), 2.5)
    create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(progress_bar, "global_position:y", 1080.0, 1.5)

    await get_tree().create_timer(2.5).timeout

    get_tree().change_scene_to_packed(game_packed_scene)

func _process(_delta):
    var status = ResourceLoader.load_threaded_get_status(game_scene_path, loading_status)

    if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
        loading_progress = loading_status[0] * 100.0

        await create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(progress_bar, "value", loading_progress, 0.1).finished
    elif status == ResourceLoader.THREAD_LOAD_LOADED:
        game_packed_scene = ResourceLoader.load_threaded_get(game_scene_path)

        await create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).tween_property(progress_bar, "value", 100.0, 2.0).finished

        loaded_game.emit()
