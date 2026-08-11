extends PlayerUpgrade
class_name ShotgunAccuracyUpgrade

func start_actions() -> void:
    Game.player.accuracy_multi *= 1.25

func end_actions() -> void:
    Game.player.accuracy_multi /= 1.25
