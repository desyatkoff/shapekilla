extends CharacterBody2D
class_name Character

@onready var body_sprite = $Body
@onready var weapon_slot = $WeaponSlot
@onready var fsm = $FiniteStateMachine

@onready var debris_container = get_tree().current_scene.get_node("DebrisContainer")

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
	
	if health == 0 and fsm.state != fsm.states.DEAD:
		die()

func _physics_process(_delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, friction)
	move_and_slide()

func move() -> void:
	velocity += (direction.normalized() * acceleration).limit_length(max_speed)

func die() -> void:
	fsm.set_state(fsm.states.DEAD)
	
	direction = Vector2.ZERO
	
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, false)
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)
	
	call_deferred("reparent", debris_container)
