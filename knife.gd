extends Weapon
class_name Knife

@onready var hitbox = $Hitbox

func _on_cooldown_timer_timeout() -> void:
    if weapon_owner.fsm.state != weapon_owner.fsm.states.DEAD:
        for body in hitbox.get_overlapping_bodies():
            if body is Player or body is Plank:
                weapon_owner.fsm.set_state(weapon_owner.fsm.states.ATTACK)

                if body is Player:
                    body.apply_noise_shake(8.0)

                attack_sfx_player.pitch_scale = randf_range(0.9, 1.1)
                attack_sfx_player.play()

                var knife_position = position
                var knife_direction = transform.x.normalized()

                create_tween().tween_property(self, "position", knife_position + knife_direction * 8, 0.2).finished.connect(func(): create_tween().tween_property(self, "position", knife_position, 0.2))

                if body is Player:
                    body.velocity += Vector2.RIGHT.rotated(rotation) * 128
                    body.take_damage(damage * weapon_owner.damage_multi)
                elif body is Plank:
                    body.destroy()

                weapon_owner.fsm.set_state(weapon_owner.fsm.previous_state)
