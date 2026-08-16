extends EnemyCharacter
class_name ProjectileEnemy

func _on_area_body_entered(body: Node2D) -> void:
    if body is Player:
        max_speed = 0

func _on_area_body_exited(body: Node2D) -> void:
    if body is Player:
        max_speed = 25
