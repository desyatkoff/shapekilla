extends Control

@onready var bg = $Background

func _ready() -> void:
	visible = true
	
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(bg, "color", Color("#21212100"), 4.0)

func _on_play_button_pressed() -> void:
	Game.hud.click_sfx_player.play()
	
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.4)
	
	tween.finished.connect(play)

func _on_quit_button_pressed() -> void:
	Game.hud.click_sfx_player.play()
	
	get_tree().quit()

func play() -> void:
	Game.player.can_play = true
	Game.player.timer_enabled = true
	
	get_parent().get_node("MouseCursor").region_rect = Rect2(32.0, 0.0, 32.0, 32.0)
	
	Game.hud.main.visible = true
	
	queue_free()
