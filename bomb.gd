extends Item
class_name Bomb

@onready var explosion_hitbox = $SelfExplosion/ExplosionHitbox
@onready var shoot_particles = $SelfExplosion/ShootParticles
@onready var explosion_particles = $SelfExplosion/ExplosionParticles
@onready var smoke_particles = $SelfExplosion/SmokeParticles
@onready var attack_sfx_player = $SelfExplosion/AttackSFXPlayer
@onready var cooldown_timer = $SelfExplosion/CooldownTimer

@onready var blood_scene = preload("res://blood_particles.tscn")

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

    shoot_particles.emitting = true
    cooldown_timer.start()

func _on_cooldown_timer_timeout() -> void:
    sprite.visible = false
    shoot_particles.emitting = false
    explosion_particles.emitting = true
    smoke_particles.emitting = true

    attack_sfx_player.pitch_scale = randf_range(0.9, 1.1)
    attack_sfx_player.play()

    for body in explosion_hitbox.get_overlapping_bodies():
        if body is Character:
            body.velocity += Vector2.RIGHT.rotated(rotation) * 128

            body.modulate = Color.RED

            tween = create_tween()
            tween.set_trans(Tween.TRANS_SINE)
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.tween_property(body, "modulate", Color.WHITE, 0.4)

            if body.fsm.state != body.fsm.states.DEAD:
                body.health -= 4

                var blood_instance = blood_scene.instantiate()
                blood_instance.global_position = body.global_position

                Game.world.get_node("DebrisContainer").add_child(blood_instance)

            Game.player.apply_noise_shake(16.0)
        elif body is Plank:
            body.destroy()

    await smoke_particles.finished

    queue_free()
