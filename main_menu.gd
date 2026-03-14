extends Control

@onready var bg = $Background

func _ready() -> void:
	visible = true
	
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(bg, "color", Color("#21212100"), 4.0)

func _on_play_button_pressed() -> void:
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	
	tween.finished.connect(play)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func play() -> void:
	get_tree().current_scene.get_node("Player").can_play = true
	get_parent().get_node("MouseCursor").region_rect = Rect2(32.0, 0.0, 32.0, 32.0)
	
	queue_free()
