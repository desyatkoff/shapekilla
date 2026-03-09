extends Weapon
class_name MeleeCombat

@onready var hitbox = $Hitbox

@onready var blood_scene = preload("res://blood_particles.tscn")

var tween: Tween

func _on_cooldown_timer_timeout() -> void:
	if weapon_owner.fsm.state != weapon_owner.fsm.states.dead:
		for body in hitbox.get_overlapping_bodies():
			if body != weapon_owner:
				if body is Character:
					body.health -= damage
					body.velocity -= body.direction * 128
					
					body.modulate = Color("#dd191d")
					
					if tween and tween.is_running():
						tween.kill()
					
					tween = create_tween()
					tween.set_trans(Tween.TRANS_SINE)
					tween.set_ease(Tween.EASE_IN_OUT)
					tween.tween_property(body, "modulate", Color.WHITE, 0.5)
					
					var blood_instance = blood_scene.instantiate()
					blood_instance.global_position = body.global_position
					
					get_tree().current_scene.get_node("Debris").add_child(blood_instance)
