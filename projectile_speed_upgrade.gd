extends PlayerUpgrade
class_name ProjectileSpeedUpgrade

func start_actions() -> void:
    Game.player.projectile_speed_multi *= 2.0

func end_actions() -> void:
    Game.player.projectile_speed_multi /= 2.0
