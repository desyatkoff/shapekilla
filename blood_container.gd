extends Node2D

func _process(_delta: float) -> void:
    visible = Game.player.current_floor > 1
