extends Node2D
class_name Portal

@onready var in_particles = $InParticles
@onready var out_particles = $OutParticles
@onready var area: = $Area2D
@onready var teleport_sfx_player = $TeleportSFXPlayer
@onready var timer = $Timer

@export var id: int
@export var in_: bool = true
@export var out_: bool = true

var pair: Portal

func _ready() -> void:
    in_particles.emitting = in_
    out_particles.emitting = out_
    area.monitoring = in_

func _on_area_2d_body_entered(body: Node2D) -> void:
    for child in get_parent().find_children("Portal*"):
        if child is Portal and child.id == id and child.out_ and child != self:
            pair = child

    if pair:
        if (body is Character or body is Projectile) or (body is Item and not body.item_owner):
            if not timer.is_stopped():
                timer.stop()

            timer.start()

            await timer.timeout

            if body in area.get_overlapping_bodies():
                teleport_sfx_player.pitch_scale = randf_range(0.9, 1.1)
                teleport_sfx_player.play()

                body.global_position = pair.global_position
