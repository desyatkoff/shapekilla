extends CharacterEffect
class_name SpeedMultiplierEffect

var multiplier = 1.5

func _ready() -> void:
    effect_texture = preload("res://speed_effect.png")
    effect_name = "x%s Speed" % multiplier

    if get_parent().get_parent() is Character:
        effect_owner = get_parent().get_parent()

        for effect in effect_owner.effects_slot.get_children():
            if effect == self:
                continue

            if effect.get_script() == get_script():
                effect.add_time(duration_timer.wait_time)
                expire_effect()

                return

        effect_owner.effects.append(self)

        if effect_owner is Player:
            var effect_icon_instance = preload("res://effect_icon.tscn").instantiate()
            effect_icon_instance.character_effect = self

            Game.hud.effects_container.add_child(effect_icon_instance)

        effect_owner.max_speed *= multiplier
        effect_owner.acceleration *= multiplier

func expire_effect() -> void:
    if effect_owner:
        effect_owner.max_speed /= multiplier
        effect_owner.acceleration /= multiplier

        effect_owner.effects.erase(self)

    queue_free()
