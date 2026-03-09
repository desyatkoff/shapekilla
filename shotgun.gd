extends Weapon
class_name Shotgun

@onready var shotgun_projectile_scene = preload("res://shotgun_projectile.tscn")

var shotgun_shots = 4
var knockback = 64

func attack():
	if cooldown.is_stopped():
		cooldown.start()

		var shotgun_position = sprite.position
		var shotgun_direction = sprite.transform.x.normalized()
		
		sprite.position -= shotgun_direction * knockback / 8
		weapon_owner.velocity -= shotgun_direction * knockback
		
		create_tween().tween_property(sprite, "position", shotgun_position, 0.2)
		
		for i in range(shotgun_shots / -2.0, shotgun_shots / 2.0):
			var shotgun_projectile_instance = shotgun_projectile_scene.instantiate()
			shotgun_projectile_instance.global_position = sprite.get_node("ProjectileSpawnPoint").global_position - Vector2(0.0, 3.0)
			shotgun_projectile_instance.global_rotation = sprite.global_rotation + i * 0.2
			shotgun_projectile_instance.weapon_owner = weapon_owner
			shotgun_projectile_instance.damage = damage
			
			get_tree().current_scene.get_node("Debris").add_child(shotgun_projectile_instance)
