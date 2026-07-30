extends Sprite2D

func _process(_delta: float) -> void:
    visible = Input.mouse_mode == Input.MOUSE_MODE_HIDDEN
    global_position = get_global_mouse_position()
