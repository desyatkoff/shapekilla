extends Character
class_name Player

@onready var item_slot = $ItemSlot
@onready var camera = $Camera2D
@onready var light = $PointLight2D

var can_play = false
var timer_enabled = false

var run_time = 0.0
var run_kills = 0
var run_rooms_cleared = 0
var run_floors_cleared = 0

var floor_time = 0.0
var floor_kills = 0
var floor_rooms_cleared = 0

var current_floor = 1

var item: Item

var noise_shake_speed = 32.0
var shake_decay_rate = 4.0
var noise = FastNoiseLite.new()
var noise_i = 0.0
var shake_strength = 0.0

func _ready() -> void:
	noise.seed = randi()

func _process(delta: float) -> void:
	health = clamp(health, 0, max_health)
	
	if health == 0 and fsm.state != fsm.states.DEAD:
		die()
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	if can_play:
		if weapon:
			weapon.rotation = lerp_angle(
				weapon.rotation,
				global_position.angle_to_point(get_global_mouse_position()),
				8.0 * delta
			)
			
			weapon.sprite.flip_v = mouse_direction.x < 0
		
		item_slot.rotation = lerp_angle(
			item_slot.rotation,
			global_position.angle_to_point(get_global_mouse_position()),
			4.0 * delta
		)
		
		body_sprite.flip_h = mouse_direction.x < 0
	
	if timer_enabled:
		run_time += delta
		floor_time += delta
	
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	
	camera.offset = get_noise_offset(delta)
	
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

func apply_noise_shake(noise_shake_strength) -> void:
	shake_strength += noise_shake_strength

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * noise_shake_speed
	
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)

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
	
	if Input.is_action_just_pressed("shoot") and weapon:
		weapon.attack()
	
	if Input.is_action_just_pressed("drop") and item:
		item.drop()
	
	if Input.is_action_just_pressed("use") and item:
		item.use()

func die() -> void:
	fsm.set_state(fsm.states.DEAD)
	
	apply_noise_shake(64.0)
	
	can_play = false
	timer_enabled = false
	
	body_sprite.region_rect = Rect2(32.0, 0.0, 32.0, 32.0)
	
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, false)
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)
	
	Game.hud.get_node("EndMenu").show_menu()

func revive() -> void:
	health = max_health
	
	fsm.set_state(fsm.states.IDLE)
	
	body_sprite.region_rect = Rect2(0.0, 0.0, 32.0, 32.0)
	
	set_collision_layer_value(2, true)
	set_collision_layer_value(3, false)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
