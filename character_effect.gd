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

        for effect in effect_owner.effects_slot.get_children():
            if effect == self:
                continue

            if effect.get_script() == get_script():
                effect.add_time(duration_timer.wait_time)
                expire_effect()

                return

        if effect_owner is Player:
            var effect_icon_instance = preload("res://effect_icon.tscn").instantiate()
            effect_icon_instance.character_effect = self

            Game.hud.effects_container.add_child(effect_icon_instance)

func _on_duration_timer_timeout() -> void:
    expire_effect()

func add_time(seconds: float) -> void:
    if duration_timer.is_stopped():
        duration_timer.start(seconds)
    else:
        duration_timer.start(duration_timer.time_left + seconds)

func expire_effect() -> void:
    effect_owner.effects.erase(self)

    queue_free()
