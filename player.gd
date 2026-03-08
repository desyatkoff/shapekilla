extends Character
class_name PlayerCharacter

@onready var shotgun_sprite = $Body/Shotgun
@onready var camera = $Camera2D
@onready var attack_cd_timer = $AttackCooldownTimer

@onready var shotgun_projectile_scene = preload("res://shotgun_projectile.tscn")

func _process(delta: float) -> void:
	shotgun_sprite.rotation = lerp_angle(shotgun_sprite.rotation, global_position.angle_to_point(get_global_mouse_position()), 10.0 * delta)
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	body_sprite.flip_h = mouse_direction.x < 0
	shotgun_sprite.flip_v = mouse_direction.x < 0
	
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
		
		var shotgun_position = shotgun_sprite.position
		var shotgun_direction = shotgun_sprite.transform.x.normalized()
		
		shotgun_sprite.position -= shotgun_direction * 8
		velocity -= shotgun_direction * 64
		
		create_tween().tween_property(shotgun_sprite, "position", shotgun_position, 0.2)
		
		for i in range(-2, 2):
			var shotgun_projectile = shotgun_projectile_scene.instantiate()
			shotgun_projectile.global_position = shotgun_sprite.global_position
			shotgun_projectile.global_rotation = shotgun_sprite.global_rotation + i * 0.2
			shotgun_projectile.who_shot = $"."
			
			get_tree().current_scene.get_node("Debris").add_child(shotgun_projectile)
