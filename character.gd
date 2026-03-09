extends CharacterBody2D
class_name Character

@onready var body_sprite = $Body
@onready var fsm = $FiniteStateMachine

@export var max_health = 10
@export var health = 10
@export var max_speed = 80
@export var acceleration = 40
@export var friction = 0.16

var weapon: Weapon

var direction = Vector2.ZERO
var current_room_slot: Node2D
var current_room_slot_id: int

func _process(_delta: float) -> void:
	health = clamp(health, 0, max_health)
	
	if health == 0 and fsm.state != fsm.states.dead:
		die()

func _physics_process(_delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, friction)
	move_and_slide()

func move() -> void:
	velocity += (direction.normalized() * acceleration).limit_length(max_speed)

func die() -> void:
	fsm.set_state(fsm.states.dead)
