extends Item
class_name Bomb

@onready var explosion_hitbox = $SelfExplosion/ExplosionHitbox
@onready var explosion_light = $SelfExplosion/ExplosionLight
@onready var flame_particles = $SelfExplosion/FlameParticles
@onready var explosion_particles = $SelfExplosion/ExplosionParticles
@onready var smoke_particles = $SelfExplosion/SmokeParticles
@onready var attack_sfx_player = $SelfExplosion/AttackSFXPlayer
@onready var cooldown_timer = $SelfExplosion/CooldownTimer

@onready var blood_scene = preload("res://blood_particles.tscn")
@onready var crack_scene = preload("res://explosion_bg_crack_particles.tscn")

func use() -> void:
    if not Game.player.cheats_enabled:
        Game.data["total_points_earned"] += 1 * Game.player.points_multi
        Game.data["total_items_used"] += 1
        Game.data["total_bombs_used"] += 1

    Game.player.run_items_used += 1
    Game.player.floor_items_used += 1

    Game.player.run_score += 10
    Game.player.run_points += 1 * Game.player.points_multi
    Game.player.run_points_earned += 1 * Game.player.points_multi

    can_be_picked_up = false

    use_sfx_player.play()

    item_owner.item = null
    item_owner = null

    call_deferred("reparent", Game.world.get_node("ItemsContainer"))

    item_particles.emitting = false

    flame_particles.emitting = true
    cooldown_timer.start()

func _on_cooldown_timer_timeout() -> void:
    explosion_light.color.a = 1.0

    create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(explosion_light, "color:a", 0.0, cooldown_timer.wait_time / 2)

    sprite.visible = false
    flame_particles.emitting = false
    explosion_particles.emitting = true
    smoke_particles.emitting = true

    attack_sfx_player.pitch_scale = randf_range(0.9, 1.1)
    attack_sfx_player.play()

    var crack_instance = crack_scene.instantiate()
    crack_instance.global_position = global_position

    Game.world.get_node("DebrisContainer").add_child(crack_instance)

    var damaged_body_count = 0

    for body in explosion_hitbox.get_overlapping_bodies():
        if body is Character:
            body.velocity += Vector2.RIGHT.rotated(rotation) * 128

            body.modulate = Color.RED

            tween = create_tween()
            tween.set_trans(Tween.TRANS_SINE)
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.tween_property(body, "modulate", Color.WHITE, 0.4)

            if body.fsm.state != body.fsm.states.DEAD:
                body.take_damage(4)
                damaged_body_count += 1
        elif body is Plank:
            body.destroy()

    Game.hitstop(0.1 * damaged_body_count, 0.1 * damaged_body_count)
    Game.player.apply_noise_shake(16.0 * clamp(damaged_body_count, 1, damaged_body_count))

    await smoke_particles.finished

    queue_free()
