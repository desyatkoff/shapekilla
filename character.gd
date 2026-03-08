extends CharacterBody2D
class_name Character

@onready var body_sprite = $Body
@onready var attack_cooldown_timer = $AttackCooldownTimer

@export var max_health = 10
@export var health = 10
@export var max_speed = 80
@export var acceleration = 40
@export var friction = 0.16

var direction = Vector2.ZERO
var current_room_slot: Node2D
var current_room_slot_id: int

func _process(_delta: float) -> void:
	if health > max_health:
		health = max_health
	
	if health <= 0:
		die()

func _physics_process(_delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, friction)
	move_and_slide()

func move() -> void:
	velocity += (direction.normalized() * acceleration).limit_length(max_speed)

func die() -> void:
	queue_free()
