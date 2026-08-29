extends RichTextLabel
class_name KillLabel

func _ready() -> void:
    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "position:y", -64, 1.5)
    tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
    tween.connect("finished", queue_free)
