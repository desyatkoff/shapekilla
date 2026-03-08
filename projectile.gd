extends Sprite2D

var who_shot: Character

func _process(delta: float) -> void:
	move_local_x(320 * delta)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body != who_shot:
		if body.get_parent() is Doors:
			body.get_parent().unlock()
		
		if body is Character:
			body.queue_free()
		
		queue_free()
