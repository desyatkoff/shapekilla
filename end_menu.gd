extends Control

@onready var bg = $Background
@onready var time = $TimeLabel/ValueLabel
@onready var kills = $KillsLabel/ValueLabel
@onready var rooms_cleared = $RoomsClearedLabel/ValueLabel

@onready var player = get_tree().current_scene.get_node("Player")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func show_menu() -> void:
	player.can_play = false
	player.timer_enabled = false
	
	time.text = "%02d:%02d.%03d" % format_time(player.time)
	kills.text = str(player.kills)
	rooms_cleared.text = str(player.rooms_cleared)
	
	visible = true
	
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(bg, "color", Color("#212121"), 4.0)
	
	get_parent().get_node("MouseCursor").region_rect = Rect2(0.0, 0.0, 32.0, 32.0)

func format_time(t: float) -> Array:
	var total_ms = int(round(t * 1000))
	var minutes = total_ms / 60000
	var seconds = (total_ms / 1000) % 60
	var milliseconds = total_ms % 1000
	
	return [int(minutes), int(seconds), int(milliseconds)]
