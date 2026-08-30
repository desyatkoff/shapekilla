extends Node2D
class_name Projectile

@onready var lifetime_timer = $LifetimeTimer

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
            body.take_damage(damage)
        elif body is Plank:
            body.destroy()

        var piercing = false

        if projectile_owner is Player:
            for upgrade in Game.player.upgrades:
                if upgrade is PiercingProjectilesUpgrade:
                    piercing = true

        if not piercing:
            queue_free()

func _on_lifetime_timer_timeout() -> void:
    queue_free()
