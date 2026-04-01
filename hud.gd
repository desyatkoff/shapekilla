extends CanvasLayer

@onready var debug = $DebugHUD

@onready var debug_info_label = $DebugHUD/DebugInfoLabel

@onready var main = $MainHUD

@onready var run_time_label = $MainHUD/RunTimeLabel
@onready var run_kills_label = $MainHUD/RunKillsLabel
@onready var run_rooms_cleared_label = $MainHUD/RunRoomsClearedLabel
@onready var floors_cleared_label = $MainHUD/FloorsClearedLabel

@onready var health_bar = $MainHUD/HealthBar
@onready var health_value_label = $MainHUD/HealthBar/HealthValueLabel

@onready var click_sfx_player = $ClickSFXPlayer

func _ready() -> void:
	visible = true
	debug.visible = OS.is_debug_build()
	main.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_hud"):
		visible = not visible
	
	if Input.is_action_just_pressed("toggle_debug_hud"):
		debug.visible = not debug.visible
	
	if Input.is_action_just_pressed("toggle_main_hud"):
		main.visible = not main.visible
	
	debug_info_label.text = \
"""fps = %s
delta = %s
states = %s
previous_state = %s
state = %s

max_health = %s
health = %s
max_speed = %s
acceleration = %s
friction = %s
weapon = %s
item = %s
velocity = %s
direction = %s
current_room_slot = %s
current_room_slot_id = %s

can_play = %s
timer_enabled = %s

run_time = %s
run_kills = %s
run_rooms_cleared = %s

floor_time = %s
floor_kills = %s
floor_rooms_cleared = %s

current_floor = %s
floors_cleared = %s
""" % \
	[
		Engine.get_frames_per_second(),
		delta,
		Game.player.fsm.states,
		Game.player.fsm.previous_state,
		Game.player.fsm.state,
		Game.player.max_health,
		Game.player.health,
		Game.player.max_speed,
		Game.player.acceleration,
		Game.player.friction,
		Game.player.weapon,
		Game.player.item,
		Game.player.velocity,
		Game.player.direction,
		Game.player.current_room_slot,
		Game.player.current_room_slot_id,
		Game.player.can_play,
		Game.player.timer_enabled,
		Game.player.run_time,
		Game.player.run_kills,
		Game.player.run_rooms_cleared,
		Game.player.floor_time,
		Game.player.floor_kills,
		Game.player.floor_rooms_cleared,
		Game.player.current_floor,
		Game.player.floors_cleared
	]
	
	run_time_label.text = "%02d:%02d.%03d" % format_time(Game.player.run_time)
	run_kills_label.text = "%s Kill%s" % [Game.player.run_kills, "s" if Game.player.run_kills == 0 or Game.player.run_kills > 1 else ""]
	run_rooms_cleared_label.text = "%s Room%s Cleared" % [Game.player.run_rooms_cleared, "s" if Game.player.run_rooms_cleared == 0 or Game.player.run_rooms_cleared > 1 else ""]
	floors_cleared_label.text = "%s Floor%s Cleared" % [Game.player.floors_cleared, "s" if Game.player.floors_cleared == 0 or Game.player.floors_cleared > 1 else ""]
	
	health_bar.value = Game.player.health
	health_bar.max_value = Game.player.max_health
	health_value_label.text = "%s / %s" % [Game.player.health, Game.player.max_health]

func format_time(t: float) -> Array:
	var total_ms = int(round(t * 1000))
	var minutes = total_ms / 60000
	var seconds = (total_ms / 1000) % 60
	var milliseconds = total_ms % 1000
	
	return [int(minutes), int(seconds), int(milliseconds)]
