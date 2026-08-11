extends PlayerUpgrade
class_name ExtraProjectileUpgrade

func start_actions() -> void:
    Game.player.weapon.shotgun_shots += 1

func end_actions() -> void:
    Game.player.weapon.shotgun_shots -= 1
