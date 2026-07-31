extends PlayerUpgrade
class_name PointsUpgrade

func start_actions() -> void:
    Game.player.points_multi *= 2

func end_actions() -> void:
    Game.player.points_multi /= 2
