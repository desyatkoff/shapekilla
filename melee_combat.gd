extends Weapon
class_name MeleeCombat

@onready var hitbox = $Hitbox

@onready var blood_scene = preload("res://blood_particles.tscn")

var tween: Tween

func _on_cooldown_timer_timeout() -> void:
	if weapon_owner.fsm.state != weapon_owner.fsm.states.DEAD:
		for body in hitbox.get_overlapping_bodies():
			if body is Player:
				weapon_owner.fsm.set_state(weapon_owner.fsm.states.ATTACK)
				
				attack_sfx_player.play()
				
				body.velocity += Vector2.RIGHT.rotated(rotation) * 128
				
				body.modulate = Color.RED
				
				if tween and tween.is_running():
					tween.kill()
				
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
