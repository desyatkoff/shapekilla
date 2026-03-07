extends Character

func _process(_delta: float) -> void:
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	look_at(get_global_mouse_position())
	
	if mouse_direction.x > 0 and sprite.flip_v:
		sprite.flip_v = false
	
	if mouse_direction.x < 0 and not sprite.flip_v:
		sprite.flip_v = true

func get_input() -> void:
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		direction += Vector2.UP
	
	if Input.is_action_pressed("left"):
		direction += Vector2.LEFT
	
	if Input.is_action_pressed("down"):
		direction += Vector2.DOWN
	
	if Input.is_action_pressed("right"):
		direction += Vector2.RIGHT
