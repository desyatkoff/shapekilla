extends Control

@onready var bg = $Background
@onready var title_label = $TitleLabel
@onready var time = $TimeLabel/ValueLabel
@onready var kills = $KillsLabel/ValueLabel
@onready var rooms_cleared = $RoomsClearedLabel/ValueLabel
@onready var floors_cleared = $FloorsClearedLabel/ValueLabel
@onready var try_again_button = $TryAgainButton
@onready var next_floor_button = $NextFloorButton
@onready var win_sfx_player = $WinSFXPlayer
@onready var lose_sfx_player = $LoseSFXPlayer

func _on_try_again_button_pressed() -> void:
	Game.hud.click_sfx_player.play()
	
	Game.reload_world()
	Game.reload_player()
	
	Game.player.revive()
	
	Game.player.run_time = 0.0
	Game.player.run_kills = 0
	Game.player.run_rooms_cleared = 0
	
	Game.player.current_floor = 1
	Game.player.floors_cleared = 0
	
	hide_menu()

func _on_next_floor_button_pressed() -> void:
	Game.hud.click_sfx_player.play()
	
	Game.reload_world()
	Game.reload_player()
	
	Game.player.current_floor += 1
	
	hide_menu()

func _on_quit_button_pressed() -> void:
	Game.hud.click_sfx_player.play()
	
	get_tree().quit()

func show_menu() -> void:
	modulate = Color.WHITE
	bg.color = Color("#21212100")
	
	Game.player.can_play = false
	Game.player.timer_enabled = false
	
	floors_cleared.text = str(Game.player.floors_cleared)
	
	if Game.player.fsm.state == Game.player.fsm.states.DEAD:
		lose_sfx_player.play()
		
		title_label.text = "YOU DIED. RUN RESULTS:"
	
		time.text = "%02d:%02d.%03d" % format_time(Game.player.run_time)
		kills.text = str(Game.player.run_kills)
		rooms_cleared.text = str(Game.player.run_rooms_cleared)
		
		floors_cleared.get_parent().visible = true
		
		try_again_button.visible = true
		next_floor_button.visible = false
	else:
		win_sfx_player.play()
		
		Game.player.floors_cleared += 1
		
		title_label.text = "FLOOR #%s RESULTS:" % Game.player.current_floor
		
		time.text = "%02d:%02d.%03d" % format_time(Game.player.floor_time)
		kills.text = str(Game.player.floor_kills)
		rooms_cleared.text = str(Game.player.floor_rooms_cleared)
		
		floors_cleared.get_parent().visible = false
		
		try_again_button.visible = false
		next_floor_button.visible = true
	
	visible = true
	
	Game.hud.main.visible = false
	
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(bg, "color", Color("#212121"), 4.0)
	
	get_parent().get_node("MouseCursor").region_rect = Rect2(0.0, 0.0, 32.0, 32.0)

func hide_menu() -> void:
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.4)
	
	tween.finished.connect(play)

func format_time(t: float) -> Array:
	var total_ms = int(round(t * 1000))
	var minutes = total_ms / 60000
	var seconds = (total_ms / 1000) % 60
	var milliseconds = total_ms % 1000
	
	return [int(minutes), int(seconds), int(milliseconds)]

func play() -> void:
	Game.player.can_play = true
	Game.player.timer_enabled = true
	
	Game.player.velocity = Vector2.ZERO
	Game.player.direction = Vector2.ZERO
	
	get_parent().get_node("MouseCursor").region_rect = Rect2(32.0, 0.0, 32.0, 32.0)
	
	visible = false
	
	Game.hud.main.visible = true
