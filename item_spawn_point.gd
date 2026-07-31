extends Node2D
class_name ItemSpawnPoint

@export var item_scenes: Array[PackedScene]
@export var probability = 1.0

func spawn_item():
    var item_scene = item_scenes.pick_random()

    if item_scene:
        var item_instance = item_scene.instantiate()

        if item_instance is Key:
            item_instance.item_tier = -1
            item_instance._ready()

        if randf() <= probability and item_instance.item_tier == Game.pick_tier():
            get_parent().add_child(item_instance)

            item_instance.global_position = global_position
        else:
            item_instance.queue_free()
