extends Weapon
class_name MeleeCombat

@onready var hitbox = $Hitbox

@onready var blood_scene = preload("res://blood_particles.tscn")

func _on_cooldown_timer_timeout() -> void:
    if weapon_owner.fsm.state != weapon_owner.fsm.states.DEAD:
        for body in hitbox.get_overlapping_bodies():
            if body is Player:
                weapon_owner.fsm.set_state(weapon_owner.fsm.states.ATTACK)

                body.apply_noise_shake(8.0)

                attack_sfx_player.pitch_scale = randf_range(0.9, 1.1)
                attack_sfx_player.play()

                body.velocity += Vector2.RIGHT.rotated(rotation) * 128
                body.take_damage(damage)

                weapon_owner.fsm.set_state(weapon_owner.fsm.previous_state)
            elif body is Plank:
                body.destroy()
