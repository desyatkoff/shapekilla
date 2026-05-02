extends RichTextLabel

func _ready() -> void:
    text = "v" + ProjectSettings.get_setting("application/config/version")
