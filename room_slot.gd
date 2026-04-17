extends Node2D
class_name RoomSlot

@export var id: int
@export var type: String

var tween: Tween

func _on_character_detector_body_entered(body: Node2D) -> void:
    body.current_room_slot = self
    body.current_room_slot_id = id
