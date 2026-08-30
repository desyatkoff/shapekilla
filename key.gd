extends Item
class_name Key

func _ready() -> void:
    if item_tier == -1:
        item_tier = randi_range(0, 4)

    item_tier = clamp(item_tier, 0, 4)

    if item_price == -1:
        item_price = round(10 * (item_tier + 1) * randf_range(0.75, 1.25))

    sprite.region_rect = Rect2(32.0 * item_tier, 0.0, 32.0, 32.0)

    match item_tier:
        0: item_name = "Gold Key"
        1: item_name = "Emerald Key"
        2: item_name = "Diamond Key"
        3: item_name = "Sapphire Key"
        4: item_name = "Amethyst Key"

    if tween and tween.is_running():
        tween.kill()

    sprite.self_modulate = Color.TRANSPARENT
    sprite.scale = Vector2.ZERO

    tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.5)
    tween.parallel().tween_property(sprite, "scale", Vector2.ONE, 0.5)

func use() -> void:
    for area in hitbox.get_overlapping_areas():
        if area.get_parent() is Doors and area.get_parent().is_locked and area.get_parent().lock_tier == item_tier:
            if not Game.player.cheats_enabled:
                Game.data["total_points_earned"] += 1 * Game.player.points_multi
                Game.data["total_items_used"] += 1
                Game.data["total_keys_used"] += 1

            Game.player.run_items_used += 1
            Game.player.floor_items_used += 1

            Game.player.run_score += 10
            Game.player.run_points += 1 * Game.player.points_multi
            Game.player.run_points_earned += 1 * Game.player.points_multi

            can_be_picked_up = false

            use_sfx_player.play()

            item_owner.item = null
            item_owner = null

            call_deferred("reparent", Game.world.get_node("ItemsContainer"))

            item_particles.emitting = false

            if tween and tween.is_running():
                tween.kill()

            tween = create_tween()
            tween.set_trans(Tween.TRANS_SINE)
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 0.5)
            tween.parallel().tween_property(sprite, "scale", Vector2.ZERO, 0.5)

            area.get_parent().unlock()
            area.get_parent().open()

            await use_sfx_player.finished

            queue_free()

            break
