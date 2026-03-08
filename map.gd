extends Node2D

@onready var slots = $RoomSlots.get_children()

@export var room_scenes: Array[PackedScene] = []

func _ready() -> void:
	randomize()
	
	var free_slots = []
	
	for slot in slots:
		if slot is RoomSlot:
			free_slots.append(slot)
	
	var pool = room_scenes.duplicate()
	pool.shuffle()
	
	for slot in free_slots:
		if slot.id != 0 and slot.id != 10:
			var room_scene = pool.pop_front()
			var room_instance = room_scene.instantiate()
			room_instance.position = Vector2.ZERO
			slot.add_child(room_instance)
