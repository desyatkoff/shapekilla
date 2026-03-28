extends CanvasLayer

@onready var debug_info_label = $Debug/DebugInfoLabel

func _ready() -> void:
	debug_info_label.visible = OS.is_debug_build()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug_info"):
		debug_info_label.visible = not debug_info_label.visible
	
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
