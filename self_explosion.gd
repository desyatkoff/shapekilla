extends Weapon
class_name SelfExplosion

@onready var hitbox = $Hitbox
@onready var explosion_particles = $ExplosionParticles
@onready var smoke_particles = $SmokeParticles

@onready var blood_scene = preload("res://blood_particles.tscn")

var did_play_sfx = false

var tween: Tween

func _on_cooldown_timer_timeout() -> void:
	if weapon_owner.fsm.state != weapon_owner.fsm.states.DEAD:
		for body in hitbox.get_overlapping_bodies():
			if body is Character:
				weapon_owner.fsm.set_state(weapon_owner.fsm.states.ATTACK)
				
				explosion_particles.emitting = true
				smoke_particles.emitting = true
				
				if not did_play_sfx:
					attack_sfx_player.pitch_scale = randf_range(0.9, 1.1)
					attack_sfx_player.play()
					did_play_sfx = true
				
				body.velocity += Vector2.RIGHT.rotated(rotation) * 128
				
				body.modulate = Color.RED
				
				tween = create_tween()
				tween.set_trans(Tween.TRANS_SINE)
				tween.set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(body, "modulate", Color.WHITE, 0.4)
				
				if body.fsm.state != body.fsm.states.DEAD:
					body.health -= damage
					
					var blood_instance = blood_scene.instantiate()
					blood_instance.global_position = body.global_position
					
					Game.world.get_node("DebrisContainer").add_child(blood_instance)
				
				weapon_owner.fsm.set_state(weapon_owner.fsm.previous_state)
		
		Game.player.apply_noise_shake(16.0)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		attack()
