extends TextureRect
class_name UpgradeIcon

@onready var panel = $Panel

var player_upgrade: PlayerUpgrade

func _ready() -> void:
    load_icon()

func load_icon() -> void:
    await ready

    if player_upgrade:
        texture = player_upgrade.upgrade_texture
        tooltip_text = "%s\n\n%s" % [player_upgrade.upgrade_name, player_upgrade.upgrade_description]

        var sb = panel.get_theme_stylebox("panel").duplicate()

        match player_upgrade.upgrade_tier:
            0: sb.border_color = Color("#ffb300")
            1: sb.border_color = Color("#7cb342")
            2: sb.border_color = Color("#00acc1")
            3: sb.border_color = Color("#3949ab")
            4: sb.border_color = Color("#8e24aa")

        panel.add_theme_stylebox_override("panel", sb)

        var tween = create_tween()
        tween.set_trans(Tween.TRANS_SINE)
        tween.set_ease(Tween.EASE_IN_OUT)
        tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.1)
        tween.tween_property(self, "scale", Vector2.ONE, 0.1)
