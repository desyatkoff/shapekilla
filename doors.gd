extends Node2D
class_name Doors

@onready var door0 = $Door_00
@onready var door1 = $Door_01
@onready var lock_sprite = $Lock
@onready var doors_sfx_player = $DoorsSFXPlayer

@export var move_offset = 32
@export var move_time = 0.5
@export var is_locked = true
@export var is_open = false
@export var lock_tier: int

var door0_closed_y: float
var door1_closed_y: float
var tween: Tween

func _ready() -> void:
    lock_tier = clamp(lock_tier, 0, 4)

    lock_sprite.region_rect = Rect2(32.0 * lock_tier, 0.0, 32.0, 32.0)

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
    is_locked = false

    var unlock_tween = create_tween()
    unlock_tween.set_trans(Tween.TRANS_SINE)
    unlock_tween.set_ease(Tween.EASE_IN_OUT)
    unlock_tween.tween_property(lock_sprite, "modulate", Color(18.892, 18.892, 18.892, 0.0), 1.0)
    unlock_tween.parallel().tween_property(lock_sprite, "scale", Vector2(1.5, 1.5), 1.0)

    await unlock_tween.finished

    lock_sprite.visible = false

    lock_sprite.modulate = Color.WHITE
    lock_sprite.scale = Vector2.ONE

func lock() -> void:
    is_locked = true

    close()

    lock_sprite.modulate = Color(18.892, 18.892, 18.892, 0.0)
    lock_sprite.scale = Vector2(1.5, 1.5)

    lock_sprite.visible = true

    var lock_tween = create_tween()
    lock_tween.set_trans(Tween.TRANS_SINE)
    lock_tween.set_ease(Tween.EASE_IN_OUT)
    lock_tween.tween_property(lock_sprite, "modulate", Color.WHITE, 1.0)
    lock_tween.parallel().tween_property(lock_sprite, "scale", Vector2.ONE, 1.0)

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
    if move_offset > 0:
        doors_sfx_player.pitch_scale = randf_range(0.9, 1.1)
        doors_sfx_player.play()

    if tween and tween.is_running():
        tween.kill()

    tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(door0, "position:y", door0_y, move_time)
    tween.parallel().tween_property(door1, "position:y", door1_y, move_time)

func _on_detector_body_entered(body: Node2D) -> void:
    if body is Character and not is_locked:
        open()

func _on_detector_body_exited(body: Node2D) -> void:
    if body is Character:
        close()
