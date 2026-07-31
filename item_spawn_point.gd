extends Node2D
class_name ItemSpawnPoint

@export var item_scenes: Array[PackedScene]
@export var probability = 1.0

var tried_spawning = false
var did_spawn = false

func spawn_item():
    if not tried_spawning:
        tried_spawning = true

        if randf() <= probability:
            did_spawn = true

    if did_spawn:
        var item_scene = item_scenes.pick_random()

        if item_scene:
            var item_instance = item_scene.instantiate()

            if item_instance is Key:
                item_instance.item_tier = -1
                item_instance._ready()

            if item_instance.item_tier == Game.pick_tier():
                get_parent().add_child(item_instance)

                item_instance.global_position = global_position
            else:
                item_instance.queue_free()

                spawn_item()
