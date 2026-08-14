extends Area2D

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        body.can_play = false
        body.timer_enabled = false

        Game.hud.get_node("EndMenu").show_menu()

        body.velocity = Vector2.RIGHT
        body.direction = Vector2.RIGHT
