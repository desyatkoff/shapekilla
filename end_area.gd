extends Area2D
class_name EndArea

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        var previous_speed = body.max_speed

        body.can_play = false
        body.timer_enabled = false

        Game.hud.get_node("EndMenu").show_menu()

        body.velocity = Vector2.RIGHT
        body.direction = Vector2.RIGHT

        body.create_tween().tween_property(body, "max_speed", 0.0, 2.5).connect(
            "finished",
            func():
                body.velocity = Vector2.ZERO
                body.direction = Vector2.ZERO
                body.max_speed = previous_speed
        )
