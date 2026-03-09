extends Node2D
class_name Doors

@onready var door0 = $Door0
@onready var door1 = $Door1
@onready var lock_sprite = $Lock

@export var move_offset = 32
@export var move_time = 0.5
@export var is_locked = true
@export var is_open = false

var door0_closed_y: float
var door1_closed_y: float
var tween: Tween

func _ready() -> void:
	door0_closed_y = door0.position.y
	door1_closed_y = door1.position.y
	lock_sprite.global_rotation = 0
	
	if is_locked:
		lock()
	else:
		unlock()
	
	if is_open:
		open()
	else:
		close()

func toggle_lock() -> void:
	if is_locked:
		lock()
	else:
		unlock()

func unlock() -> void:
	lock_sprite.visible = false
	is_locked = false

func lock() -> void:
	lock_sprite.visible = true
	is_locked = true

func toggle() -> void:
	if not is_locked:
		if is_open:
			close()
		else:
			open()

func open() -> void:
	if not is_open and not is_locked:
		_move_doors(
			door0_closed_y - move_offset,
			door1_closed_y + move_offset
		)
		
		is_open = true

func close() -> void:
	if is_open:
		_move_doors(
			door0_closed_y,
			door1_closed_y
		)
		
		is_open = false

func _move_doors(door0_y: float, door1_y: float) -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(door0, "position:y", door0_y, move_time)
	tween.parallel().tween_property(door1, "position:y", door1_y, move_time)

func _on_character_detector_body_entered(body: Node2D) -> void:
	if body is Character:
		if body is Player:
			for child in body.get_children():
				if child is Key and is_locked:
					child.queue_free()
					unlock()
		
		if not is_locked and not is_open:
			open()

func _on_character_detector_body_exited(body: Node2D) -> void:
	if body is Character and is_open:
		close()
