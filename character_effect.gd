extends Node
class_name CharacterEffect

@onready var duration_timer = $DurationTimer

var effect_texture: Texture2D
var effect_name: String
var effect_owner: Character

func _ready() -> void:
    if get_parent().get_parent() is Character:
        effect_owner = get_parent().get_parent()
        effect_owner.effects.append(self)

        if effect_owner is Player:
            var effect_icon_instance = preload("res://effect_icon.tscn").instantiate()
            effect_icon_instance.character_effect = self

            Game.hud.effects_container.add_child(effect_icon_instance)

func _on_duration_timer_timeout() -> void:
    expire_effect()

func expire_effect() -> void:
    effect_owner.effects.erase(self)

    queue_free()
