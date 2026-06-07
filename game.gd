extends Node2D

var world: Node2D
var player: Player
var hud: CanvasLayer

var is_tutorial_complete = false

var total_play_time = 0.0
var total_runs = 0

var total_kills = 0
var best_kills = 0

var total_rooms_cleared = 0
var best_rooms_cleared = 0

var total_floors_cleared = 0
var best_floors_cleared = 0

var total_items_used = 0
var best_items_used = 0

var total_keys_used = 0
var total_health_potions_used = 0
var total_damage_potions_used = 0
var total_speed_potions_used = 0

func _ready() -> void:
    var data = load_data()

    if not data.is_empty():
        apply_save_data(data)

func _process(_delta: float) -> void:
    if is_instance_valid(player):
        if player.run_kills > best_kills:
            best_kills = player.run_kills

            save_progress()

        if player.run_rooms_cleared > best_rooms_cleared:
            best_rooms_cleared = player.run_rooms_cleared

            save_progress()

        if player.run_floors_cleared > best_floors_cleared:
            best_floors_cleared = player.run_floors_cleared

            save_progress()

        if player.run_items_used > best_items_used:
            best_items_used = player.run_items_used

            save_progress()

func update_values() -> void:
    world = get_tree().current_scene.get_node("World")
    player = get_tree().current_scene.get_node("Player")
    hud = get_tree().current_scene.get_node("HUD")

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
    if player.weapon:
        player.weapon.queue_free()

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

func collect_save_data() -> Dictionary:
    return {
        "is_tutorial_complete": is_tutorial_complete,
        "total_play_time": total_play_time,
        "total_runs": total_runs,
        "total_kills": total_kills,
        "best_kills": best_kills,
        "total_rooms_cleared": total_rooms_cleared,
        "best_rooms_cleared": best_rooms_cleared,
        "total_floors_cleared": total_floors_cleared,
        "best_floors_cleared": best_floors_cleared,
        "total_items_used": total_items_used,
        "best_items_used": best_items_used,
        "total_keys_used": total_keys_used,
        "total_health_potions_used": total_health_potions_used,
        "total_damage_potions_used": total_damage_potions_used,
        "total_speed_potions_used": total_speed_potions_used
    }

func apply_save_data(data: Dictionary) -> void:
    is_tutorial_complete = data.get("is_tutorial_complete", is_tutorial_complete)

    total_play_time = data.get("total_play_time", total_play_time)
    total_runs = data.get("total_runs", total_runs)

    total_kills = data.get("total_kills", total_kills)
    best_kills = data.get("best_kills", best_kills)

    total_rooms_cleared = data.get("total_rooms_cleared", total_rooms_cleared)
    best_rooms_cleared = data.get("best_rooms_cleared", best_rooms_cleared)

    total_floors_cleared = data.get("total_floors_cleared", total_floors_cleared)
    best_floors_cleared = data.get("best_floors_cleared", best_floors_cleared)

    total_items_used = data.get("total_items_used", total_items_used)
    best_items_used = data.get("best_items_used", best_items_used)

    total_keys_used = data.get("total_keys_used", total_keys_used)
    total_health_potions_used = data.get("total_health_potions_used", total_health_potions_used)
    total_damage_potions_used = data.get("total_damage_potions_used", total_damage_potions_used)
    total_speed_potions_used = data.get("total_speed_potions_used", total_speed_potions_used)

func erase_save_data() -> void:
    if FileAccess.file_exists("user://save.dat"):
        DirAccess.remove_absolute("user://save.dat")

    is_tutorial_complete = false

    total_play_time = 0.0
    total_runs = 0

    total_kills = 0
    best_kills = 0

    total_rooms_cleared = 0
    best_rooms_cleared = 0

    total_floors_cleared = 0
    best_floors_cleared = 0

    total_items_used = 0
    best_items_used = 0

    total_keys_used = 0
    total_health_potions_used = 0
    total_damage_potions_used = 0
    total_speed_potions_used = 0

func save_progress() -> void:
    var existing = load_data()

    if existing.is_empty() and FileAccess.file_exists("user://save.dat"):
        return

    var current = collect_save_data()
    var merged_data = {}

    for key in current.keys():
        var cur = current.get(key)
        var old = existing.get(key, cur)

        if typeof(cur) == TYPE_BOOL:
            merged_data[key] = cur or old
        else:
            merged_data[key] = max(cur, old)

    save_data(merged_data)

func save_data(data: Dictionary) -> bool:
    var file = FileAccess.open("user://save.dat", FileAccess.WRITE)

    if file:
        file.store_var(data, false)
        file.close()

        return true
    else:
        return false

func load_data() -> Dictionary:
    if not FileAccess.file_exists("user://save.dat"):
        return {}

    var file = FileAccess.open("user://save.dat", FileAccess.READ)

    if file:
        var data = file.get_var(false)

        file.close()

        if typeof(data) != TYPE_DICTIONARY:
            return {}
        else:
            return data
    else:
        return {}
