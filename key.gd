extends Item
class_name Key

func use() -> void:
    for area in hitbox.get_overlapping_areas():
        if area.get_parent() is Doors:
            can_be_picked_up = false

            use_sfx_player.play()

            if not Game.player.cheats_enabled:
                Game.total_keys_used += 1

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

            area.get_parent().unlock()
            area.get_parent().open()

            await use_sfx_player.finished

            queue_free()
