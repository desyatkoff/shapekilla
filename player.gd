extends Character
class_name Player

@onready var camera = $Camera2D
@onready var light = $PointLight2D

func _process(delta: float) -> void:
	health = clamp(health, 0, max_health)
	
	if health == 0 and fsm.state != fsm.states.dead:
		die()
	
	if fsm.state == fsm.states.dead:
		return
	
	weapon.sprite.rotation = lerp_angle(
		weapon.sprite.rotation,
		global_position.angle_to_point(get_global_mouse_position()),
		10.0 * delta
	)
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	body_sprite.flip_h = mouse_direction.x < 0
	weapon.sprite.flip_v = mouse_direction.x < 0
	
	match current_room_slot_id:
		0:
			camera.limit_left = -256
			camera.limit_top = -128
			camera.limit_right = 288
			camera.limit_bottom = 128
		1:
			camera.limit_left = 256
			camera.limit_top = -768
			camera.limit_right = 800
			camera.limit_bottom = -224
		2:
			camera.limit_left = 736
			camera.limit_top = -768
			camera.limit_right = 1312
			camera.limit_bottom = -224
		3:
			camera.limit_left = 1248
			camera.limit_top = -768
			camera.limit_right = 1792
			camera.limit_bottom = -224
		4:
			camera.limit_left = 224
			camera.limit_top = -288
			camera.limit_right = 800
			camera.limit_bottom = 288
		5:
			camera.limit_left = 736
			camera.limit_top = -288
			camera.limit_right = 1312
			camera.limit_bottom = 288
		6:
			camera.limit_left = 1248
			camera.limit_top = -288
			camera.limit_right = 1824
			camera.limit_bottom = 288
		7:
			camera.limit_left = 256
			camera.limit_top = 224
			camera.limit_right = 800
			camera.limit_bottom = 768
		8:
			camera.limit_left = 736
			camera.limit_top = 224
			camera.limit_right = 1312
			camera.limit_bottom = 768
		9:
			camera.limit_left = 1248
			camera.limit_top = 224
			camera.limit_right = 1792
			camera.limit_bottom = 768
		10:
			camera.limit_left = 1760
			camera.limit_top = -128
			camera.limit_right = 2304
			camera.limit_bottom = 128

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
	
	if Input.is_action_just_pressed("shoot"):
		weapon.attack()

func die() -> void:
	fsm.set_state(fsm.states.dead)
	body_sprite.region_rect = Rect2(32.0, 0.0, 32.0, 32.0)
	set_collision_layer_value(2, false)
