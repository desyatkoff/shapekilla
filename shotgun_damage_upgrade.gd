extends PlayerUpgrade
class_name ShotgunDamageUpgrade

func start_actions() -> void:
    Game.player.weapon.damage += 1

func end_actions() -> void:
    Game.player.weapon.damage -= 1
