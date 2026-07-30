extends PlayerUpgrade
class_name SpeedUpgrade

func start_actions() -> void:
    Game.player.speed_multi *= 1.25

func end_actions() -> void:
    Game.player.speed_multi /= 1.25
