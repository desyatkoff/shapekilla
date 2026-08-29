extends TextureRect
class_name EffectIcon

@onready var name_label = $Name
@onready var duration_label = $Duration

var character_effect: CharacterEffect
var previous_character_effect: CharacterEffect

func _process(_delta: float) -> void:
    if character_effect:
        texture = character_effect.effect_texture
        name_label.text = character_effect.effect_name
        duration_label.text = "%.1f s" % character_effect.duration_timer.time_left

        if character_effect != previous_character_effect:
            var tween = create_tween()
            tween.set_trans(Tween.TRANS_SINE)
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.1)
            tween.tween_property(self, "scale", Vector2.ONE, 0.1)
    else:
        texture = null
        name_label.text = ""
        duration_label.text = ""

        queue_free()

    previous_character_effect = character_effect
