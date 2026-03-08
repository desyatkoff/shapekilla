extends EnemyCharacter
class_name MeleeEnemyCharacter

@onready var hitbox = $Hitbox

func _on_attack_cooldown_timer_timeout() -> void:
	for body in hitbox.get_overlapping_bodies():
		if body is PlayerCharacter:
			body.health -= 1
