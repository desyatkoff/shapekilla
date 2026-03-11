extends Node2D
class_name Room

signal cleared

@onready var items_container = get_tree().current_scene.get_node("ItemsContainer")

@onready var key_scene = preload("res://key.tscn")

@export var type: String

var enemies_alive = 0

func _on_enemy_died():
	enemies_alive -= 1

	if enemies_alive == 0:
		cleared.emit()
		
		var key_instance = key_scene.instantiate()
		key_instance.global_position = get_parent().global_position
		key_instance.global_rotation = get_parent().global_rotation
		
		items_container.call_deferred("add_child", key_instance)

func register_enemy(enemy):
	enemies_alive += 1
	enemy.died.connect(_on_enemy_died)
