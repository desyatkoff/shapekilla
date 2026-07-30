extends CharacterEffect
class_name DamageMultiplierEffect

var multiplier = 2.0

func _ready() -> void:
    if round(multiplier) == multiplier:
        multiplier = int(multiplier)

    effect_texture = preload("res://damage_effect.png")
    effect_name = "x%s Damage" % multiplier

    if get_parent().get_parent() is Character:
        effect_owner = get_parent().get_parent()

        if effect_owner.weapon:
            effect_owner.damage_multi *= multiplier

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

func expire_effect() -> void:
    if effect_owner:
        if effect_owner.weapon:
            effect_owner.damage_multi /= multiplier

        effect_owner.effects.erase(self)

    queue_free()
