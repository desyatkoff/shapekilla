extends CPUParticles2D

@onready var area_2d = $Area2D
@onready var vampirism_sfx_player = $VampirismSFXPlayer

var consumable = true

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is Player:
        for upgrade in Game.player.upgrades:
            if upgrade is VampirismUpgrade:
                if consumable:
                    consumable = false

                    vampirism_sfx_player.pitch_scale = randf_range(0.9, 1.1)
                    vampirism_sfx_player.play()

                    body.health += 1.0 / body.weapon.shotgun_shots * 2.0

                    break

func _on_timer_timeout() -> void:
    area_2d.queue_free()
    vampirism_sfx_player.queue_free()

    consumable = false

    set_physics_process(false)
    set_physics_process_internal(false)
    set_process(false)
    set_process_input(false)
    set_process_internal(false)
    set_process_shortcut_input(false)
    set_process_unhandled_input(false)
    set_process_unhandled_key_input(false)
