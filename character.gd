extends CharacterBody2D
class_name Character

@onready var sprite = $Sprite2D

@export var max_speed = 80
@export var acceleration = 40
@export var friction = 0.16

var direction = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, friction)
	move_and_slide()

func move() -> void:
	velocity += (direction.normalized() * acceleration).limit_length(max_speed)
