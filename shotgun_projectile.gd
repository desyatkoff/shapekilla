extends Sprite2D

@onready var lifetime_timer = $Lifetime

var who_shot: Character

func _ready() -> void:
	lifetime_timer.wait_time = clamp(randf() * 2, 0.25, 1)
	lifetime_timer.start()
	
	reparent(get_tree().current_scene.get_node("Debris"))

func _process(delta: float) -> void:
	move_local_x(320 * delta)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body != who_shot:
		if body is Character:
			body.health -= 1
			body.velocity -= body.direction * 128
		
		queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()
