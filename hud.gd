extends CanvasLayer

@onready var debug_info_label = $Control/DebugInfoLabel

var player: Player

func _ready() -> void:
	debug_info_label.visible = OS.is_debug_build()
	player = get_tree().current_scene.get_node("Player")

func _process(delta: float) -> void:
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
""" % \
	[
		Engine.get_frames_per_second(),
		delta,
		player.fsm.states,
		player.fsm.previous_state,
		player.fsm.state,
		player.max_health,
		player.health,
		player.max_speed,
		player.acceleration,
		player.friction,
		player.weapon,
		player.item,
		player.velocity,
		player.direction,
		player.current_room_slot,
		player.current_room_slot_id,
	]
