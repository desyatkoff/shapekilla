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
	
	if get_parent() is Player:
		position = get_parent().weapon.sprite.transform.x.normalized() * 32

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		call_deferred("reparent", body)
