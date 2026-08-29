extends CharacterBody2D
class_name Character

@onready var dust_particles = $DustParticles
@onready var body_sprite = $Body
@onready var weapon_slot = $WeaponSlot
@onready var effects_slot = $EffectsSlot
@onready var hurt_sfx_player = $HurtSFXPlayer
@onready var fsm = $FiniteStateMachine
@onready var blood_scene = preload("res://blood_particles.tscn")

@export var max_health = 10
@export var health = 10
@export var max_speed = 80
@export var acceleration = 40
@export var friction = 0.16

var health_multi = 1.0
var damage_multi = 1.0
var speed_multi = 1.0
var projectile_speed_multi = 1.0
var accuracy_multi = 1.0

var weapon: Weapon

var effects: Array[CharacterEffect]

var direction = Vector2.ZERO
var current_room_slot: Node2D
var current_room_slot_id: int

var move_time = 0.0

func _process(_delta: float) -> void:
    health = int(clamp(health, 0, max_health))

    if health == 0 and fsm.state != fsm.states.DEAD:
        die()

func _physics_process(delta: float) -> void:
    velocity = lerp(velocity, Vector2.ZERO, friction)

    dust_particles.emitting = velocity.length() > 1.0
    dust_particles.direction = -direction

    var degrees = randf_range(2.5, 5.0)

    if velocity.length() > 5.0:
        move_time += delta * degrees

        body_sprite.rotation = sin(move_time) * deg_to_rad(degrees)
        body_sprite.skew = sin(move_time) * deg_to_rad(degrees)
    else:
        move_time = 0.0

        body_sprite.rotation = lerp(body_sprite.rotation, 0.0, degrees / 10.0)
        body_sprite.skew = lerp(body_sprite.skew, 0.0, degrees / 10.0)

    move_and_slide()

func move() -> void:
    velocity += (direction.normalized() * acceleration * speed_multi).limit_length(max_speed * speed_multi)

func take_damage(damage: int) -> void:
    hurt_sfx_player.pitch_scale = randf_range(0.9, 1.1)
    hurt_sfx_player.play()

    modulate = Color.RED

    if fsm.state != fsm.states.DEAD:
        health -= damage

        var blood_instance = blood_scene.instantiate()
        blood_instance.global_position = global_position

        Game.world.get_node("DebrisContainer").add_child(blood_instance)

        if get_script() == Player:
            Game.player.run_points -= 1
            Game.player.run_points_earned -= 1
            Game.player.run_points_spent -= 1

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "modulate", Color.WHITE, 0.25)

func die() -> void:
    fsm.set_state(fsm.states.DEAD)

    direction = Vector2.ZERO

    set_collision_layer_value(2, false)
    set_collision_layer_value(3, false)
    set_collision_mask_value(2, false)
    set_collision_mask_value(3, false)

    call_deferred("reparent", Game.world.get_node("DebrisContainer"))
