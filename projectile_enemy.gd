extends EnemyCharacter
class_name ProjectileEnemy

var previous_speed

func _on_area_body_entered(body: Node2D) -> void:
    previous_speed = max_speed

    if body is Player:
        max_speed = 0

func _on_area_body_exited(body: Node2D) -> void:
    if body is Player:
        max_speed = previous_speed
