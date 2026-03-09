extends Node2D
class_name Weapon

@onready var sprite = $Sprite
@onready var cooldown = $CooldownTimer

@onready var weapon_owner = get_parent().get_parent()

@export var damage = 1

func _ready() -> void:
	weapon_owner.weapon = self

func attack():
	if cooldown.is_stopped():
		cooldown.start()
