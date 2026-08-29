extends Node2D

var custom_seed = null
var run_seed = null

var canvas_modulate: CanvasModulate
var world: Node2D
var player: Player
var hud: CanvasLayer

var console

const DEFAULT_SETTINGS = {
    "max_fps": 60,
    "fullscreen": true,
    "vsync": true,
    "audio_volume": 100
}

var settings = DEFAULT_SETTINGS.duplicate(true)

var data = {
    "is_tutorial_complete": false,
    "total_play_time": 0.0,
    "total_runs": 0,
    "high_score": 0,
    "total_points_earned": 0,
    "best_points_earned": 0,
    "total_points_spent": 0,
    "best_points_spent": 0,
    "total_kills": 0,
    "best_kills": 0,
    "total_rooms_cleared": 0,
    "best_rooms_cleared": 0,
    "total_floors_cleared": 0,
    "best_floors_cleared": 0,
    "total_items_used": 0,
    "best_items_used": 0,
    "total_keys_used": 0,
    "total_health_potions_used": 0,
    "total_damage_potions_used": 0,
    "total_speed_potions_used": 0,
    "total_poison_potions_used": 0,
    "total_bombs_used": 0
}

func _ready() -> void:
    var loaded_data = load_data()

    if not loaded_data.is_empty():
        data = loaded_data

func _process(_delta: float) -> void:
    load_settings()
    apply_all_settings()

    if is_instance_valid(player):
        if not player.cheats_enabled:
            if player.run_score > data["high_score"]:
                data["high_score"] = player.run_score

                save_progress()

            if player.run_points_earned > data["best_points_earned"]:
                data["best_points_earned"] = player.run_points_earned

                save_progress()

            if player.run_points_spent > data["best_points_spent"]:
                data["best_points_spent"] = player.run_points_spent

                save_progress()

            if player.run_kills > data["best_kills"]:
                data["best_kills"] = player.run_kills

                save_progress()

            if player.run_rooms_cleared > data["best_rooms_cleared"]:
                data["best_rooms_cleared"] = player.run_rooms_cleared

                save_progress()

            if player.run_floors_cleared > data["best_floors_cleared"]:
                data["best_floors_cleared"] = player.run_floors_cleared

                save_progress()

            if player.run_items_used > data["best_items_used"]:
                data["best_items_used"] = player.run_items_used

                save_progress()

func pick_tier() -> int:
    var weights = [64, 24, 6, 4, 2]

    var total = 0

    for w in weights:
        total += w

    var roll = randi_range(1, total)

    var sum = 0

    for i in range(weights.size()):
        sum += weights[i]

        if roll <= sum:
            return i

    return 0

func hitstop(hitstop_duration: float, screen_flash_time: float) -> void:
    if screen_flash_time > 0.0:
        Game.hud.hitstop.modulate = Color(Color.WHITE, 0.5)

    if hitstop_duration > 0.0:
        Engine.time_scale = 0.0
        await get_tree().create_timer(hitstop_duration, true, false, true).timeout
        Engine.time_scale = 1.0

    if screen_flash_time > 0.0:
        var tween = create_tween()
        tween.set_trans(Tween.TRANS_SINE)
        tween.set_ease(Tween.EASE_IN_OUT)
        tween.tween_property(Game.hud.hitstop, "modulate", Color.TRANSPARENT, screen_flash_time)

func update_values() -> void:
    if custom_seed and run_seed != custom_seed:
        run_seed = custom_seed
    else:
        run_seed = randi()

    seed(run_seed)

    canvas_modulate = get_tree().current_scene.get_node("CanvasModulate")
    world = get_tree().current_scene.get_node("World")
    player = get_tree().current_scene.get_node("Player")
    hud = get_tree().current_scene.get_node("HUD")

    if not player.cheats_enabled:
        save_progress()

func reload_world() -> void:
    var world_node_index = world.get_index()
    var world_node_transform = world.global_transform

    var world_scene = load(world.scene_file_path)

    world.free()

    var world_instance = world_scene.instantiate()

    world = world_instance

    get_tree().current_scene.add_child(world_instance)
    get_tree().current_scene.move_child(world_instance, world_node_index)

    world_instance.global_transform = world_node_transform

    update_values()

func reload_player() -> void:
    if player.fsm.state == player.fsm.states.DEAD:
        for effect in player.effects_slot.get_children():
            effect.expire_effect()

        for effect_icon in hud.effects_container.get_children():
            effect_icon.queue_free()

        for upgrade in player.upgrades_slot.get_children():
            upgrade.expire_upgrade()

        for upgrade_icon in hud.upgrades_container.get_children():
            upgrade_icon.queue_free()

        if player.item:
            var item = player.item
            item.drop()
            item.queue_free()

    player.floor_time = 0.0
    player.floor_kills = 0
    player.floor_rooms_cleared = 0
    player.floor_items_used = 0

    player.global_transform = world.get_node("PlayerSpawnPoint").global_transform

    update_values()

func load_settings() -> void:
    if not FileAccess.file_exists("user://settings.json"):
        save_settings()

        return

    var file = FileAccess.open("user://settings.json", FileAccess.READ)
    var settings_data = JSON.parse_string(file.get_as_text())

    if settings_data is Dictionary:
        for key in DEFAULT_SETTINGS:
            if settings_data.has(key):
                settings[key] = settings_data[key]

func save_settings() -> void:
    var file = FileAccess.open("user://settings.json", FileAccess.WRITE)

    file.store_string(JSON.stringify(settings, "\t", false, true))

func set_max_fps(value: int) -> void:
    settings["max_fps"] = int(value)

    apply_max_fps()
    save_settings()

func set_fullscreen(value: bool) -> void:
    settings["fullscreen"] = value

    apply_fullscreen()
    save_settings()

func set_vsync(value: bool) -> void:
    settings["vsync"] = value

    apply_vsync()
    save_settings()

func set_audio_volume(value: float) -> void:
    settings["audio_volume"] = int(value)

    apply_audio_volume()
    save_settings()

func apply_all_settings() -> void:
    apply_max_fps()
    apply_fullscreen()
    apply_vsync()
    apply_audio_volume()

func apply_max_fps() -> void:
    Engine.max_fps = settings["max_fps"]

func apply_fullscreen() -> void:
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if settings["fullscreen"] else DisplayServer.WINDOW_MODE_WINDOWED)

func apply_vsync() -> void:
    DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if settings["vsync"] else DisplayServer.VSYNC_DISABLED)

func apply_audio_volume() -> void:
    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index("Master"),
        linear_to_db(settings["audio_volume"] / 100)
    )

func erase_save_data() -> void:
    if FileAccess.file_exists("user://save.json"):
        DirAccess.remove_absolute("user://save.json")

    data = {
        "is_tutorial_complete": false,
        "total_play_time": 0.0,
        "total_runs": 0,
        "high_score": 0,
        "total_points_earned": 0,
        "best_points_earned": 0,
        "total_points_spent": 0,
        "best_points_spent": 0,
        "total_kills": 0,
        "best_kills": 0,
        "total_rooms_cleared": 0,
        "best_rooms_cleared": 0,
        "total_floors_cleared": 0,
        "best_floors_cleared": 0,
        "total_items_used": 0,
        "best_items_used": 0,
        "total_keys_used": 0,
        "total_health_potions_used": 0,
        "total_damage_potions_used": 0,
        "total_speed_potions_used": 0,
        "total_poison_potions_used": 0,
        "total_bombs_used": 0
    }

func save_progress() -> void:
    if player.cheats_enabled:
        return

    var existing = load_data()

    if existing.is_empty() and FileAccess.file_exists("user://save.json"):
        return

    var current = data
    var merged_data = {}

    for key in current.keys():
        var cur = current.get(key)
        var old = existing.get(key, cur)

        if cur is bool:
            merged_data[key] = cur or old
        else:
            merged_data[key] = max(cur, old)

    save_data(merged_data)

func save_data(data_dict: Dictionary) -> bool:
    var file = FileAccess.open("user://save.json", FileAccess.WRITE)

    if file:
        file.store_string(JSON.stringify(data_dict, "\t", false, true))
        file.close()

        return true
    else:
        return false

func load_data() -> Dictionary:
    if not FileAccess.file_exists("user://save.json"):
        return {}

    var file = FileAccess.open("user://save.json", FileAccess.READ)

    if file:
        var data_dict = JSON.parse_string(file.get_as_text())

        for key in data_dict.keys():
            if data_dict[key] is float and round(data_dict[key]) == data_dict[key]:
                data_dict[key] = int(data_dict[key])

        file.close()

        return data_dict if data_dict is Dictionary else {}
    else:
        return {}
