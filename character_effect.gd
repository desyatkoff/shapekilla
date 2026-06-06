extends Node
class_name CharacterEffect

var effect_owner: Character

func _ready() -> void:
    if get_parent().get_parent() is Character:
        effect_owner = get_parent().get_parent()
        effect_owner.effects.append(self)

func _on_duration_timer_timeout() -> void:
    expire_effect()

func expire_effect() -> void:
    effect_owner.effects.erase(self)

    queue_free()
