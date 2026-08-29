extends Character
class_name Player

@onready var upgrades_slot = $UpgradesSlot
@onready var item_slot = $ItemSlot
@onready var camera = $Camera2D
@onready var light = $PointLight2D

var can_play = false
var timer_enabled = false

var cheats_enabled = false
var noclip = false

var is_wizard_killed = false

var points_multi = 1

var run_time = 0.0
var run_score = 0
var run_points = 0
var run_points_earned = 0
var run_points_spent = 0
var run_kills = 0
var run_rooms_cleared = 0
var run_floors_cleared = 0
var run_items_used = 0

var floor_time = 0.0
var floor_kills = 0
var floor_rooms_cleared = 0
var floor_items_used = 0

var current_floor = 1

var max_upgrades = 20
var upgrades: Array[PlayerUpgrade]

var item: Item

var noise_shake_speed = 32.0
var shake_decay_rate = 4.0
var noise = FastNoiseLite.new()
var noise_i = 0.0
var shake_strength = 0.0

func _ready() -> void:
    noise.seed = randi()

    if not Game.data["is_tutorial_complete"]:
        current_floor = 0
        find_child("Shotgun").queue_free()

func _process(delta: float) -> void:
    if Game.data["is_tutorial_complete"]:
        health = clamp(health, 0, max_health)
    else:
        health = clamp(health, 1, max_health)

    health = int(round(health))

    Game.canvas_modulate.color = Color.WHITE.lerp(Color(1.0, 0.5, 0.5), pow(1.0 - float(health) / float(max_health), 2.0))

    run_points = clampi(run_points, 0, run_points)
    run_points_earned = clampi(run_points_earned, 0, run_points_earned)
    run_points_spent = clampi(run_points_spent, 0, run_points_spent)

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
        Game.data["total_play_time"] += delta

        run_time += delta
        floor_time += delta

    shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)

    camera.offset = get_noise_offset(delta)

    camera.limit_enabled = current_room_slot_id != -1 and not noclip

    set_collision_layer_value(2, not noclip)

    set_collision_mask_value(1, not noclip)
    set_collision_mask_value(2, not noclip)
    set_collision_mask_value(3, not noclip)
    set_collision_mask_value(5, not noclip)

    if current_floor > 0:
        match current_room_slot_id:
            0:
                camera.limit_left = -256
                camera.limit_top = -256
                camera.limit_right = 288
                camera.limit_bottom = 256
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
                camera.limit_top = -256
                camera.limit_right = 2304
                camera.limit_bottom = 256
    else:
        match current_room_slot_id:
            0:
                camera.limit_left = -3328
                camera.limit_top = -256
                camera.limit_right = -2784
                camera.limit_bottom = 256
            1:
                camera.limit_left = -2848
                camera.limit_top = -256
                camera.limit_right = -2272
                camera.limit_bottom = 256
            2:
                camera.limit_left = -2336
                camera.limit_top = -256
                camera.limit_right = -1760
                camera.limit_bottom = 256
            3:
                camera.limit_left = -1824
                camera.limit_top = -256
                camera.limit_right = -1248
                camera.limit_bottom = 256
            4:
                camera.limit_left = -1312
                camera.limit_top = -256
                camera.limit_right = -736
                camera.limit_bottom = 256
            5:
                camera.limit_left = -800
                camera.limit_top = -256
                camera.limit_right = -256
                camera.limit_bottom = 256

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

    if Game.hud.find_child("ConsoleMenu").panel.visible:
        return

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
