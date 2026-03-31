extends Node2D

@onready var room_slots = $RoomSlots.get_children()

@export var room_scenes: Array[PackedScene]

func _ready() -> void:
	randomize()
	
	var free_room_slots = []
	
	for slot in room_slots:
		free_room_slots.append(slot)
	
	var pool = room_scenes.duplicate()
	pool.shuffle()
	
	for slot in free_room_slots:
		if pool.is_empty():
			break
		
		var matching_rooms = []
		
		for room_scene in room_scenes:
			var temp_room_instance = room_scene.instantiate()
			
			if temp_room_instance.type == slot.type:
				matching_rooms.append(room_scene)
			
			temp_room_instance.queue_free()
		
		var room_scene = matching_rooms.pick_random()
		
		if room_scene:
			var room_instance = room_scene.instantiate()
			room_instance.position = Vector2.ZERO
			
			slot.add_child(room_instance)
			
			for child in room_instance.get_children():
				if child is EnemySpawnPoint:
					child.spawn_enemy()
