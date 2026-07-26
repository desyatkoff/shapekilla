extends Item
class_name Key

@export var key_tier: int

func _ready() -> void:
    key_tier = clamp(key_tier, 0, 4)

    sprite.region_rect = Rect2(32.0 * key_tier, 0.0, 32.0, 32.0)

    match key_tier:
        0: item_name = "Gold Key"
        1: item_name = "Emerald Key"
        2: item_name = "Diamond Key"
        3: item_name = "Sapphire Key"
        4: item_name = "Amethyst Key"

func pick_tier() -> int:
    var weights = [50, 30, 15, 4, 1]

    var total = 0

    for w in weights:
        total += w

    var roll = randi_range(1, total)

    var sum = 0

    for i in range(weights.size()):
        sum += weights[i]

        if roll <= sum:
            return i

    return 0

func use() -> void:
    for area in hitbox.get_overlapping_areas():
        if area.get_parent() is Doors and area.get_parent().is_locked and area.get_parent().lock_tier == key_tier:
            if not Game.player.cheats_enabled:
                Game.data["total_points_earned"] += 1
                Game.data["total_items_used"] += 1
                Game.data["total_keys_used"] += 1

            Game.player.run_items_used += 1
            Game.player.floor_items_used += 1

            Game.player.run_score += 10
            Game.player.run_points += 1
            Game.player.run_points_earned += 1

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
            tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 0.25)

            area.get_parent().unlock()
            area.get_parent().open()

            await use_sfx_player.finished

            queue_free()

            break
