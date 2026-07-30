extends Panel
class_name TradeItemCard

signal purchased

@onready var icon = $Icon
@onready var info_label = $InfoLabel
@onready var purchase_button = $PurchaseButton
@onready var purchase_sfx_player = $PurchaseSFXPlayer

var is_purchased = false
var item: Node

func _ready() -> void:
    icon.texture = AtlasTexture.new()

    if item is Item:
        var sb = get_theme_stylebox("panel").duplicate()
        var tier_info = []

        match item.item_tier:
            0: tier_info = ["Common", Color("#ffb300")]
            1: tier_info = ["Uncommon", Color("#7cb342")]
            2: tier_info = ["Rare", Color("#00acc1")]
            3: tier_info = ["Epic", Color("#3949ab")]
            4: tier_info = ["Legendary", Color("#8e24aa")]

        sb.border_color = tier_info[1]
        add_theme_stylebox_override("panel", sb)

        icon.texture.atlas = item.sprite.texture
        icon.texture.region = item.sprite.region_rect
        info_label.text = \
"""
[color=#757575]Name:[/color] %s
[color=#757575]Type:[/color] [color=#eeeeee]Item[/color]
[color=#757575]Tier:[/color] [color=#%s]%s[/color]
[color=#757575]Price:[/color] %s Points
""" % \
        [
            item.item_name,
            tier_info[1].to_html(false),
            tier_info[0],
            item.item_price
        ]
    elif item is PlayerUpgrade:
        var sb = get_theme_stylebox("panel").duplicate()
        var tier_info = []

        match item.upgrade_tier:
            0: tier_info = ["Common", Color("#ffb300")]
            1: tier_info = ["Uncommon", Color("#7cb342")]
            2: tier_info = ["Rare", Color("#00acc1")]
            3: tier_info = ["Epic", Color("#3949ab")]
            4: tier_info = ["Legendary", Color("#8e24aa")]

        sb.border_color = tier_info[1]
        add_theme_stylebox_override("panel", sb)

        icon.texture.atlas = item.upgrade_texture
        info_label.text = \
"""
[color=#757575]Name:[/color] %s
[color=#757575]Type:[/color] [color=#f48fb1]Upgrade[/color]
[color=#757575]Tier:[/color] [color=#%s]%s[/color]
[color=#757575]Price:[/color] %s Points
""" % \
        [
            item.upgrade_name,
            tier_info[1].to_html(false),
            tier_info[0],
            item.upgrade_price
        ]

    check_availability()

func _on_purchase_button_pressed() -> void:
    var item_clone: Node = item.duplicate()
    get_parent().add_child(item_clone)

    if item_clone is Item:
        if not Game.player.cheats_enabled:
            Game.data["total_points_spent"] += item_clone.item_price

        Game.player.run_points -= item_clone.item_price
        Game.player.run_points_spent += item_clone.item_price

        purchased.emit()
        is_purchased = true

        purchase_sfx_player.pitch_scale = randf_range(0.9, 1.1)
        purchase_sfx_player.play()

        if Game.player.item:
            Game.player.item.drop()

        item_clone.pickup(Game.player)
    elif item_clone is PlayerUpgrade:
        if not Game.player.cheats_enabled:
            Game.data["total_points_spent"] += item_clone.upgrade_price

        Game.player.run_points -= item_clone.upgrade_price
        Game.player.run_points_spent += item_clone.upgrade_price

        purchased.emit()
        is_purchased = true

        purchase_sfx_player.pitch_scale = randf_range(0.9, 1.1)
        purchase_sfx_player.play()

        item_clone.gain_upgrade()

    check_availability()

func check_availability() -> void:
    if item is Item:
        purchase_button.disabled = item.item_price > Game.player.run_points
    elif item is PlayerUpgrade:
        purchase_button.disabled = item.upgrade_price > Game.player.run_points

    if is_purchased:
        purchase_button.disabled = true
