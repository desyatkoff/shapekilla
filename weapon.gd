extends Node2D
class_name Weapon

@onready var sprite = $Sprite
@onready var attack_sfx_player = $AttackSFXPlayer
@onready var cooldown = $CooldownTimer

@onready var weapon_owner: Character

@export var damage = 1

func _ready() -> void:
    if get_parent().get_parent() is Character:
        weapon_owner = get_parent().get_parent()
        weapon_owner.weapon = self

func attack():
    if cooldown.is_stopped():
        cooldown.start()
