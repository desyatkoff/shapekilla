extends Character
class_name EnemyCharacter

signal died

@onready var nav_agent = $NavigationAgent2D
@onready var nav_timer = $NavigationTimer
@onready var kill_label_scene = preload("res://kill_label.tscn")

var should_check_player = true
var should_chase_player = false

func _ready() -> void:
    while not Game.player:
        await get_tree().process_frame

    health_multi = clamp(1.0 + (Game.player.current_floor - 1) / 20.0, 1.0, 2.0)
    max_health *= health_multi
    health = max_health
    speed_multi = clamp(1.0 + (Game.player.current_floor - 1) / 20.0, 1.0, 2.0)
    max_speed /= 4

    if get_parent() is Room:
        get_parent().register_enemy(self)

    await get_tree().process_frame

    owner = null
    call_deferred("reparent", Game.world.get_node("EnemiesContainer"))

func _process(delta: float) -> void:
    health = clamp(health, 0, max_health)

    if health == 0.0 and fsm.state != fsm.states.DEAD:
        die()

    if should_check_player:
        if Game.player.current_room_slot_id == current_room_slot_id:
            should_check_player = false
            should_chase_player = true
        else:
            should_chase_player = false

    if fsm.state == fsm.states.CHASE or fsm.state == fsm.states.ATTACK:
        var player_direction = (Game.player.global_position - global_position).normalized()

        body_sprite.flip_h = player_direction.x < 0
        weapon.sprite.flip_v = player_direction.x < 0

        weapon.rotation = lerp_angle(
            weapon.rotation,
            global_position.angle_to_point(Game.player.global_position),
            8.0 * delta
        )

func _get_path_to_player() -> void:
    if fsm.state == fsm.states.CHASE and Game.player.fsm.state != Game.player.fsm.states.DEAD:
        nav_agent.target_position = Game.player.global_position
    else:
        nav_agent.target_position = global_position

func _on_navigation_timer_timeout() -> void:
    if should_chase_player:
        fsm.set_state(fsm.states.CHASE)
        _get_path_to_player()
    else:
        if fsm.state != fsm.states.DEAD:
            fsm.set_state(fsm.states.IDLE)
            direction = lerp(direction, Vector2.ZERO, friction)

func chase() -> void:
    direction = (nav_agent.get_next_path_position() - global_position).normalized()

func die() -> void:
    fsm.set_state(fsm.states.DEAD)
    died.emit()

    if not Game.player.cheats_enabled:
        Game.data["total_points_earned"] += 1 * Game.player.points_multi
        Game.data["total_kills"] += 1

    Game.player.run_kills += 1
    Game.player.floor_kills += 1

    Game.player.run_score += 10
    Game.player.run_points += 1 * Game.player.points_multi
    Game.player.run_points_earned += 1 * Game.player.points_multi

    direction = Vector2.ZERO
    should_chase_player = false
    body_sprite.region_rect = Rect2(32.0, 0.0, 32.0, 32.0)

    set_collision_layer_value(2, false)
    set_collision_layer_value(3, false)
    set_collision_mask_value(2, false)
    set_collision_mask_value(3, false)

    call_deferred("reparent", Game.world.get_node("DebrisContainer"))

    add_child(kill_label_scene.instantiate())
