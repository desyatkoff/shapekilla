extends Weapon
class_name Shotgun

@onready var item_particles = $ItemParticles

@onready var shotgun_projectile_scene = preload("res://shotgun_projectile.tscn")
@onready var shoot_particles_scene = preload("res://shoot_particles.tscn")

var shotgun_shots = 4
var knockback = 64

func _process(delta: float) -> void:
    if weapon_owner:
        global_position = global_position.move_toward(
            weapon_owner.weapon_slot.global_position + Vector2(0.0, 5.0),
            32 * delta
        )

func _on_hitbox_body_entered(body: Node2D) -> void:
    if body is Player and not body.weapon:
        weapon_owner = body
        weapon_owner.weapon = self
        global_rotation = 0.0
        item_particles.queue_free()

        call_deferred("reparent", body.weapon_slot)

func attack():
    if cooldown.is_stopped():
        cooldown.start()

        weapon_owner.fsm.set_state(weapon_owner.fsm.states.ATTACK)

        weapon_owner.apply_noise_shake(4.0)

        attack_sfx_player.pitch_scale = randf_range(0.9, 1.1)
        attack_sfx_player.play()

        var shoot_particles_instance = shoot_particles_scene.instantiate()
        shoot_particles_instance.global_position = sprite.get_node("ProjectileSpawnPoint").global_position - Vector2(0.0, 3.0)
        shoot_particles_instance.global_rotation = global_rotation
        shoot_particles_instance.emitting = true

        Game.world.get_node("DebrisContainer").add_child(shoot_particles_instance)

        var shotgun_position = position
        var shotgun_direction = transform.x.normalized()

        position -= shotgun_direction * knockback / 8
        weapon_owner.velocity -= shotgun_direction * knockback

        create_tween().tween_property(self, "position", shotgun_position, cooldown.wait_time / 2)

        for i in range(ceili(shotgun_shots / -2.0), ceili(shotgun_shots / 2.0)):
            var shotgun_projectile_instance = shotgun_projectile_scene.instantiate()
            shotgun_projectile_instance.projectile_owner = weapon_owner
            shotgun_projectile_instance.damage = damage * weapon_owner.damage_multi
            shotgun_projectile_instance.speed = 256 * weapon_owner.projectile_speed_multi
            shotgun_projectile_instance.knockback = knockback * 2
            shotgun_projectile_instance.global_position = sprite.get_node("ProjectileSpawnPoint").global_position - Vector2(0.0, 3.0)
            shotgun_projectile_instance.global_rotation = global_rotation + i * 0.2 / weapon_owner.accuracy_multi

            Game.world.get_node("DebrisContainer").add_child(shotgun_projectile_instance)

        weapon_owner.fsm.set_state(weapon_owner.fsm.previous_state)
