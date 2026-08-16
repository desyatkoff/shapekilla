extends Weapon
class_name StoneProjectileShooter

@onready var stone_projectile_scene = preload("res://stone_projectile.tscn")
@onready var shoot_particles_scene = preload("res://shoot_particles.tscn")
@onready var hitbox = $Hitbox

func _process(delta: float) -> void:
    if weapon_owner:
        global_position = global_position.move_toward(
            weapon_owner.weapon_slot.global_position + Vector2(0.0, 5.0),
            32 * delta
        )

func _on_cooldown_timer_timeout() -> void:
    if weapon_owner.fsm.state != weapon_owner.fsm.states.DEAD:
        for body in hitbox.get_overlapping_bodies():
            if body is Player:
                weapon_owner.fsm.set_state(weapon_owner.fsm.states.ATTACK)

                attack_sfx_player.pitch_scale = randf_range(0.9, 1.1)
                attack_sfx_player.play()

                var shoot_particles_instance = shoot_particles_scene.instantiate()
                shoot_particles_instance.global_position = global_position
                shoot_particles_instance.global_rotation = global_rotation
                shoot_particles_instance.emitting = true

                Game.world.get_node("DebrisContainer").add_child(shoot_particles_instance)

                var stone_projectile_instance = stone_projectile_scene.instantiate()
                stone_projectile_instance.projectile_owner = weapon_owner
                stone_projectile_instance.damage = damage * weapon_owner.damage_multi
                stone_projectile_instance.speed = 256 * weapon_owner.projectile_speed_multi
                stone_projectile_instance.knockback = 128
                stone_projectile_instance.global_position = global_position
                stone_projectile_instance.global_rotation = global_rotation

                Game.world.get_node("DebrisContainer").add_child(stone_projectile_instance)

                weapon_owner.fsm.set_state(weapon_owner.fsm.previous_state)
