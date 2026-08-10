extends StaticBody2D
class_name Plank

@onready var particles = $Particles
@onready var destroy_sfx_player = $DestroySFXPlayer

@export var is_breakable = true

func destroy() -> void:
    if is_breakable:
        particles.emitting = true
        particles.reparent(Game.world.get_node("DebrisContainer"))

        destroy_sfx_player.pitch_scale = randf_range(0.9, 1.1)
        destroy_sfx_player.play()
        destroy_sfx_player.reparent(Game.world.get_node("DebrisContainer"))

        queue_free()
