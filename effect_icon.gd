extends TextureRect
class_name EffectIcon

@onready var name_label = $Name
@onready var duration_label = $Duration

var character_effect: CharacterEffect

func _process(_delta: float) -> void:
    if character_effect:
        texture = character_effect.effect_texture
        name_label.text = character_effect.effect_name
        duration_label.text = "%.1f s" % character_effect.duration_timer.time_left
    else:
        texture = null
        name_label.text = ""
        duration_label.text = ""

        queue_free()
