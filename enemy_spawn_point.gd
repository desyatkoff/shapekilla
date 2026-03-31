extends Node2D
class_name EnemySpawnPoint

@export var enemy_scenes: Array[PackedScene]

func _ready() -> void:
	randomize()

func spawn_enemy():
	var enemy_scene = enemy_scenes.pick_random()
	
	if enemy_scene:
		var enemy_instance = enemy_scene.instantiate()
		
		get_parent().add_child(enemy_instance)
		
		enemy_instance.global_position = global_position
