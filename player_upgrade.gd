extends Node
class_name PlayerUpgrade

@export var upgrade_texture: Texture2D
@export var upgrade_name: String
@export var upgrade_description: String
@export var upgrade_tier: int

func _ready() -> void:
    upgrade_tier = clamp(upgrade_tier, 0, 4)

    if get_parent().get_parent() is Player:
        var upgrade_icon_instance = preload("res://upgrade_icon.tscn").instantiate()
        upgrade_icon_instance.player_upgrade = self

        Game.player.upgrades.append(self)

        Game.hud.upgrades_container.add_child(upgrade_icon_instance)

        start_actions()

func _process(delta: float) -> void:
    cycle_actions(delta)

func start_actions() -> void:
    pass

func cycle_actions(_delta: float) -> void:
    pass

func end_actions() -> void:
    pass

func expire_upgrade() -> void:
    end_actions()

    Game.player.upgrades.erase(self)

    queue_free()
