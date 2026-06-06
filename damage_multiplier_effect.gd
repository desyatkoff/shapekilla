extends CharacterEffect
class_name DamageMultiplierEffect

@export var multiplier = 2

func _ready() -> void:
    if get_parent().get_parent() is Character:
        effect_owner = get_parent().get_parent()
        effect_owner.effects.append(self)

        if effect_owner.weapon:
            effect_owner.weapon.damage *= 2

func expire_effect() -> void:
    if effect_owner:
        if effect_owner.weapon:
            effect_owner.weapon.damage /= 2

        effect_owner.effects.erase(self)

    queue_free()
