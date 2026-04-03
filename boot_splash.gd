extends Control

@onready var logo = $Logo

func _ready() -> void:
	logo.modulate = Color.TRANSPARENT
	
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(logo, "modulate", Color.WHITE, 0.5)

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
