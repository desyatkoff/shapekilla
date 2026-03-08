extends Character
class_name PlayerCharacter

@onready var camera = $Camera2D
@onready var attack_cd_timer = $AttackCooldownTimer

@onready var projectile_scene = preload("res://projectile.tscn")

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and sprite.flip_v:
		sprite.flip_v = false
	
	if mouse_direction.x < 0 and not sprite.flip_v:
		sprite.flip_v = true
	
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
	
	if Input.is_action_just_pressed("shoot") and attack_cd_timer.is_stopped():
		attack_cd_timer.start()
		
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.global_rotation = global_rotation
		projectile.who_shot = $"."
		
		get_tree().current_scene.add_child(projectile)
