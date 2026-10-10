extends Node
class_name PlayerUpgrade

@export var upgrade_texture: Texture2D
@export var upgrade_name: String
@export var upgrade_description: String
@export var upgrade_tier: int
@export var upgrade_price: int = -1
@export var max_stacks: int = -1

func _ready() -> void:
    upgrade_tier = clamp(upgrade_tier, 0, 4)

    if upgrade_price == -1:
        upgrade_price = round(10 * (upgrade_tier + 1) * randf_range(0.75, 1.25) * (2 if Game.insane_mode else 1))

    if get_parent() != null and get_parent().get_parent() is Player:
        gain_upgrade()

func _process(delta: float) -> void:
    cycle_actions(delta)

func start_actions() -> void:
    pass

func cycle_actions(_delta: float) -> void:
    pass

func end_actions() -> void:
    pass

func gain_upgrade() -> void:
    var upgrade_icon_instance = preload("res://upgrade_icon.tscn").instantiate()
    upgrade_icon_instance.player_upgrade = self
    upgrade_icon_instance.load_icon()

    reparent(Game.player.upgrades_slot)
    Game.player.upgrades.append(self)

    Game.hud.upgrades_container.add_child(upgrade_icon_instance)

    start_actions()

func expire_upgrade() -> void:
    end_actions()

    Game.player.upgrades.erase(self)

    queue_free()
