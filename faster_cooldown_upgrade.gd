extends PlayerUpgrade
class_name FasterCooldownUpgrade

func start_actions() -> void:
    Game.player.weapon.cooldown.wait_time /= 1.5

func end_actions() -> void:
    Game.player.weapon.shotgun_shots *= 1.5
