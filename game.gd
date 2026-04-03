extends Node2D

var world: Node2D
var player: Player
var hud: CanvasLayer

var total_play_time = 0.0
var total_kills = 0
var total_rooms_cleared = 0
var total_floors_cleared = 0
var total_runs = 0

func _ready() -> void:
	var data = load_data()
	
	if not data.is_empty():
		apply_save_data(data)

func _process(delta: float) -> void:
	total_play_time += delta

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
	player.floor_time = 0.0
	player.floor_kills = 0
	player.floor_rooms_cleared = 0
	
	player.global_transform = world.get_node("PlayerSpawnPoint").global_transform
	
	update_values()

func collect_save_data() -> Dictionary:
	return {
		"total_play_time": total_play_time,
		"total_kills": total_kills,
		"total_rooms_cleared": total_rooms_cleared,
		"total_floors_cleared": total_floors_cleared,
		"total_runs": total_runs
	}

func apply_save_data(data: Dictionary) -> void:
	total_play_time = data.get("total_play_time", total_play_time)
	total_kills = data.get("total_kills", total_kills)
	total_rooms_cleared = data.get("total_rooms_cleared", total_rooms_cleared)
	total_floors_cleared = data.get("total_floors_cleared", total_floors_cleared)
	total_runs = data.get("total_runs", total_runs)

func save_progress() -> void:
	var existing = load_data()
	
	if existing.is_empty() and FileAccess.file_exists("user://save.dat"):
		return
	
	var current = collect_save_data()
	
	var merged_data = {}
	
	for key in current.keys():
		merged_data[key] = max(current.get(key, 0), existing.get(key, 0))
	
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
