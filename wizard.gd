extends Character
class_name Wizard

@onready var trade_hitbox = $TradeHitbox
@onready var kill_label_scene = preload("res://kill_label.tscn")

func _ready() -> void:
    if Game.player.is_wizard_killed:
        queue_free()

func _process(_delta: float) -> void:
    health = clamp(health, 0, max_health)

    if health == 0 and fsm.state != fsm.states.DEAD:
        die()

func _on_trade_hitbox_body_entered(body: Node2D) -> void:
    if body is Player:
        Game.hud.trade_menu.show_menu()

func die() -> void:
    fsm.set_state(fsm.states.DEAD)

    trade_hitbox.monitoring = false

    if not Game.player.cheats_enabled:
        Game.data["total_points_earned"] += 1 * Game.player.points_multi
        Game.data["total_kills"] += 1

    Game.player.is_wizard_killed = true

    Game.player.run_kills += 1
    Game.player.floor_kills += 1

    Game.player.run_score += 10
    Game.player.run_points += 1 * Game.player.points_multi
    Game.player.run_points_earned += 1 * Game.player.points_multi

    direction = Vector2.ZERO

    body_sprite.region_rect = Rect2(32.0, 0.0, 32.0, 32.0)

    set_collision_layer_value(2, false)
    set_collision_layer_value(3, false)
    set_collision_mask_value(2, false)
    set_collision_mask_value(3, false)

    call_deferred("reparent", Game.world.get_node("DebrisContainer"))

    add_child(kill_label_scene.instantiate())
