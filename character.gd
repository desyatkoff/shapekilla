extends CharacterBody2D
class_name Character

@onready var body_sprite = $Body
@onready var weapon_slot = $WeaponSlot
@onready var effects_slot = $EffectsSlot
@onready var hurt_sfx_player = $HurtSFXPlayer
@onready var fsm = $FiniteStateMachine

@export var max_health = 10
@export var health = 10
@export var max_speed = 80
@export var acceleration = 40
@export var friction = 0.16

var damage_multi = 1.0
var speed_multi = 1.0
var projectile_speed_multi = 1.0
var accuracy_multi = 1.0

var weapon: Weapon

var effects: Array[CharacterEffect]

var direction = Vector2.ZERO
var current_room_slot: Node2D
var current_room_slot_id: int

func _process(_delta: float) -> void:
    health = int(clamp(health, 0, max_health))

    if health == 0 and fsm.state != fsm.states.DEAD:
        die()

func _physics_process(_delta: float) -> void:
    velocity = lerp(velocity, Vector2.ZERO, friction)
    move_and_slide()

func move() -> void:
    velocity += (direction.normalized() * acceleration * speed_multi).limit_length(max_speed * speed_multi)

func die() -> void:
    fsm.set_state(fsm.states.DEAD)

    direction = Vector2.ZERO

    set_collision_layer_value(2, false)
    set_collision_layer_value(3, false)
    set_collision_mask_value(2, false)
    set_collision_mask_value(3, false)

    call_deferred("reparent", Game.world.get_node("DebrisContainer"))
