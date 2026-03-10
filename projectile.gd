extends Node2D
class_name Projectile

@onready var lifetime_timer = $LifetimeTimer

@onready var debris_container = get_tree().current_scene.get_node("DebrisContainer")

@onready var blood_scene = preload("res://blood_particles.tscn")

var projectile_owner: Character
var tween: Tween

var damage: int

func _ready() -> void:
	lifetime_timer.wait_time = clamp(randf(), 0.25, 1)
	lifetime_timer.start()

func _process(delta: float) -> void:
	move_local_x(320 * delta)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body != projectile_owner:
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
			
			debris_container.add_child(blood_instance)
		else:
			queue_free()

func _on_lifetime_timer_timeout() -> void:
	queue_free()
