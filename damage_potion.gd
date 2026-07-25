extends Item
class_name DamagePotion

func use() -> void:
    if not Game.player.cheats_enabled:
        Game.data["total_items_used"] += 1
        Game.data["total_damage_potions_used"] += 1

    Game.player.run_items_used += 1
    Game.player.floor_items_used += 1

    Game.player.run_score += 10
    Game.player.run_points += 1

    use_sfx_player.play()

    item_owner.effects_slot.add_child(preload("res://damage_multiplier_effect.tscn").instantiate())

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
