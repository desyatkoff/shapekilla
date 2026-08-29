extends Weapon
class_name SelfExplosion

@onready var hitbox = $Hitbox
@onready var explosion_light = $ExplosionLight
@onready var explosion_particles = $ExplosionParticles
@onready var smoke_particles = $SmokeParticles

@onready var blood_scene = preload("res://blood_particles.tscn")
@onready var crack_scene = preload("res://explosion_bg_crack_particles.tscn")

var did_play_sfx = false
var did_crack = false

func _on_cooldown_timer_timeout() -> void:
    did_play_sfx = false
    did_crack = false

    var damaged_body_count = 0

    if weapon_owner.fsm.state != weapon_owner.fsm.states.DEAD:
        for body in hitbox.get_overlapping_bodies():
            if body is Character:
                weapon_owner.fsm.set_state(weapon_owner.fsm.states.ATTACK)

                explosion_light.color.a = 1.0

                create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).tween_property(explosion_light, "color:a", 0.0, cooldown.wait_time / 2)

                explosion_particles.emitting = true
                smoke_particles.emitting = true

                if not did_play_sfx:
                    attack_sfx_player.pitch_scale = randf_range(0.9, 1.1)
                    attack_sfx_player.play()
                    did_play_sfx = true

                if not did_crack:
                    var crack_instance = crack_scene.instantiate()
                    crack_instance.global_position = global_position

                    Game.world.get_node("DebrisContainer").add_child(crack_instance)

                    did_crack = true

                body.velocity += Vector2.RIGHT.rotated(rotation) * 128
                body.take_damage(damage)

                if body != self:
                    damaged_body_count += 1

                weapon_owner.fsm.set_state(weapon_owner.fsm.previous_state)
            elif body is Plank:
                body.destroy()

        Game.hitstop(0.1 * damaged_body_count, 0.1 * damaged_body_count)
        Game.player.apply_noise_shake(16.0 * clamp(damaged_body_count, 1, damaged_body_count))

func _on_hitbox_body_entered(body: Node2D) -> void:
    if body is Player:
        attack()
