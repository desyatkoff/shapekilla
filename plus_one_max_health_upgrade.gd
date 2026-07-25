extends PlayerUpgrade
class_name PlusOneMaxHealthUpgrade

func start_actions() -> void:
    Game.player.max_health += 1

func end_actions() -> void:
    Game.player.max_health -= 1
