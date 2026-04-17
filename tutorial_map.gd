extends Node2D

@onready var key_scene = preload("res://key.tscn")

@onready var slot_03_message = $RoomSlots/RoomSlot_03/MessageLabel_00
@onready var key_spawn_point = $RoomSlots/RoomSlot_03/KeySpawnPoint
@onready var timer = $RoomSlots/RoomSlot_03/Timer

var did_shot_the_door = false

func _on_projectile_detector_area_entered(area: Area2D) -> void:
    if area.get_parent() is ShotgunProjectile and not did_shot_the_door:
        did_shot_the_door = true
        timer.start()

        slot_03_message.text += "[type]. Wait... Yeah, your beloved shotgun won't help in this kind of situation. I guess you need a [color=#ffc107]Key[/color]...\n[Q] to drop, [E] to use[/type]"

func _on_timer_timeout() -> void:
    var key_instance = key_scene.instantiate()
    key_instance.global_position = key_spawn_point.global_position
    key_instance.global_rotation = key_spawn_point.global_rotation

    Game.world.get_node("ItemsContainer").call_deferred("add_child", key_instance)
