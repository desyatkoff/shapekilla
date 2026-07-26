extends PlayerUpgrade
class_name PlusOneHealthRegenUpgrade

var time_since_last_regen = 0.0

func cycle_actions(delta: float) -> void:
    time_since_last_regen += delta

    if time_since_last_regen > 10.0:
        Game.player.health += 1

        time_since_last_regen = 0.0
