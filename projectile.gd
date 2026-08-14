extends Node2D
class_name Projectile

@onready var lifetime_timer = $LifetimeTimer

@onready var blood_scene = preload("res://blood_particles.tscn")

var projectile_owner: Character

var damage: int
var speed: int
var knockback: int

func _ready() -> void:
    lifetime_timer.wait_time = clamp(randf(), 0.2, 1.0)
    lifetime_timer.start()

func _process(delta: float) -> void:
    move_local_x(speed * delta)

func _on_hitbox_body_entered(body: Node2D) -> void:
    if body != projectile_owner:
        if body is Character:
            body.velocity += Vector2.RIGHT.rotated(rotation) * knockback

            body.modulate = Color.RED

            var tween = body.create_tween()
            tween.set_trans(Tween.TRANS_SINE)
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.tween_property(body, "modulate", Color.WHITE, 0.4)

            if body.fsm.state != body.fsm.states.DEAD:
                body.health -= damage
                body.hurt_sfx_player.pitch_scale = randf_range(0.9, 1.1)
                body.hurt_sfx_player.play()

                var blood_instance = blood_scene.instantiate()
                blood_instance.global_position = body.global_position

                Game.world.get_node("DebrisContainer").add_child(blood_instance)
        elif body is Plank:
            body.destroy()
        else:
            queue_free()

        var piercing = false

        if projectile_owner is Player:
            for upgrade in Game.player.upgrades:
                if upgrade is PiercingProjectilesUpgrade:
                    piercing = true

        if not piercing:
            queue_free()

func _on_lifetime_timer_timeout() -> void:
    queue_free()
