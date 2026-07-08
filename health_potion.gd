extends Item
class_name HealthPotion

@export var heal = 2

func use() -> void:
    use_sfx_player.play()

    if not Game.player.cheats_enabled:
        Game.data["total_health_potions_used"] += 1

    item_owner.health += heal

    item_owner.item = null
    item_owner = null

    call_deferred("reparent", Game.world.get_node("ItemsContainer"))

    item_particles.emitting = false

    if tween and tween.is_running():
        tween.kill()

    tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 0.25)

    await use_sfx_player.finished

    queue_free()
