extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().current_scene.get_node("HUD").get_node("EndMenu").show_menu()
