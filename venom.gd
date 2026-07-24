extends Weapon
class_name Venom

@onready var hitbox = $Hitbox

@onready var poison_effect = preload("res://poison_effect.tscn")

var tween: Tween

func _on_cooldown_timer_timeout() -> void:
    if weapon_owner.fsm.state != weapon_owner.fsm.states.DEAD:
        for body in hitbox.get_overlapping_bodies():
            if body is Player:
                for effect in body.effects_slot.get_children():
                    if effect is PoisonEffect:
                        return

                weapon_owner.fsm.set_state(weapon_owner.fsm.states.ATTACK)

                if body.fsm.state != body.fsm.states.DEAD:
                    body.effects_slot.add_child(poison_effect.instantiate())

                weapon_owner.fsm.set_state(weapon_owner.fsm.previous_state)
