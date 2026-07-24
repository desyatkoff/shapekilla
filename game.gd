extends Node2D

var custom_seed = null
var run_seed = null

var world: Node2D
var player: Player
var hud: CanvasLayer

var console

var data = {
    "is_tutorial_complete": false,
    "total_play_time": 0.0,
    "total_runs": 0,
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
    "total_poison_potions_used": 0
}

func _ready() -> void:
    var loaded_data = load_data()

    if not loaded_data.is_empty():
        data = loaded_data

func _process(_delta: float) -> void:
    if is_instance_valid(player):
        if not player.cheats_enabled:
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

func update_values() -> void:
    if custom_seed and run_seed != custom_seed:
        run_seed = custom_seed
    else:
        run_seed = randi()

    seed(run_seed)

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

        for effect in hud.effects_container.get_children():
            effect.queue_free()

        if player.item:
            player.item.queue_free()

    player.floor_time = 0.0
    player.floor_kills = 0
    player.floor_rooms_cleared = 0
    player.floor_items_used = 0

    player.global_transform = world.get_node("PlayerSpawnPoint").global_transform

    update_values()

func erase_save_data() -> void:
    if FileAccess.file_exists("user://save.json"):
        DirAccess.remove_absolute("user://save.json")

    data = {
        "is_tutorial_complete": false,
        "total_play_time": 0.0,
        "total_runs": 0,
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
        "total_poison_potions_used": 0
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
