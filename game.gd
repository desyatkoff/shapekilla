extends Node2D

var world: Node2D
var player: Player
var hud: CanvasLayer

func update_values() -> void:
	world = get_tree().current_scene.get_node("World")
	player = get_tree().current_scene.get_node("Player")
	hud = get_tree().current_scene.get_node("HUD")

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
