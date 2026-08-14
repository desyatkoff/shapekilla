extends PlayerUpgrade
class_name KnockbackUpgrade

func start_actions() -> void:
    Game.player.weapon.knockback *= 1.5

func end_actions() -> void:
    Game.player.weapon.knockback /= 1.5
