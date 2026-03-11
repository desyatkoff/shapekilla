extends Node2D
class_name RoomSlot

@export var id: int
@export var type: String

var tween: Tween

func _ready() -> void:
	visible = false

func _on_character_detector_body_entered(body: Node2D) -> void:
	body.current_room_slot = self
	body.current_room_slot_id = id
	
	if body is Player and not visible:
		get_child(1).self_modulate = Color.TRANSPARENT
		
		visible = true
		
		tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(get_child(1), "self_modulate", Color.WHITE, 1)
