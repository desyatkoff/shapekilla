extends Item
class_name PoisonPotion

@onready var poison_effect = preload("res://poison_effect.tscn")

func use() -> void:
    use_sfx_player.play()

    if not Game.player.cheats_enabled:
        Game.data["total_poison_potions_used"] += 1

    item_owner.effects_slot.add_child(poison_effect.instantiate())

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
