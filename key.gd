extends Sprite2D
class_name Key

func _ready() -> void:
	self_modulate = Color.TRANSPARENT
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "self_modulate", Color.WHITE, 1)

func _process(delta: float) -> void:
	rotate(delta)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		call_deferred("reparent", body)
		call_deferred("set_position", Vector2(16, 0))
