extends StaticBody2D
class_name Plank

@onready var particles = $Particles
@onready var sprite = $Sprite2D
@onready var destroy_sfx_player = $DestroySFXPlayer

@export var is_breakable = true

func destroy() -> void:
    if is_breakable:
        is_breakable = false

        for i in range(25):
            sprite.position = Vector2(
                randf_range(-1.0, 1.0),
                randf_range(-1.0, 1.0)
            )

            await get_tree().create_timer(0.01).timeout

        particles.emitting = true
        particles.reparent(Game.world.get_node("DebrisContainer"))

        destroy_sfx_player.pitch_scale = randf_range(0.9, 1.1)
        destroy_sfx_player.play()
        destroy_sfx_player.reparent(Game.world.get_node("DebrisContainer"))

        queue_free()
