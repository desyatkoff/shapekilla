extends CharacterEffect
class_name DamageMultiplierEffect

@export var multiplier = 2

func _ready() -> void:
    effect_texture = preload("res://damage_potion.png")
    effect_name = "x%s Damage" % multiplier

    if get_parent().get_parent() is Character:
        effect_owner = get_parent().get_parent()
        effect_owner.effects.append(self)

        if effect_owner is Player:
            var effect_icon_instance = preload("res://effect_icon.tscn").instantiate()
            effect_icon_instance.character_effect = self

            Game.hud.effects_container.add_child(effect_icon_instance)

        if effect_owner.weapon:
            effect_owner.weapon.damage *= 2

func expire_effect() -> void:
    if effect_owner:
        if effect_owner.weapon:
            effect_owner.weapon.damage /= 2

        effect_owner.effects.erase(self)

    queue_free()
