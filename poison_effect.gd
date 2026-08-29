extends CharacterEffect
class_name PoisonEffect

@onready var attack_sfx_player = $AttackSFXPlayer

var damage = 1

var hit = 0
var time_since_last_hit = 1

var tween: Tween

func _ready() -> void:
    effect_texture = preload("res://poison_effect.png")
    effect_name = "Poison"

    if get_parent().get_parent() is Character:
        effect_owner = get_parent().get_parent()

        for effect in effect_owner.effects_slot.get_children():
            if effect == self:
                continue

            if effect.get_script() == get_script():
                effect.add_time(duration_timer.wait_time)
                expire_effect()

                return

        effect_owner.effects.append(self)

        if effect_owner is Player:
            var effect_icon_instance = preload("res://effect_icon.tscn").instantiate()
            effect_icon_instance.character_effect = self

            Game.hud.effects_container.add_child(effect_icon_instance)

func _process(delta: float) -> void:
    if not effect_owner:
        return

    time_since_last_hit += delta

    if time_since_last_hit >= 1:
        if effect_owner.health > damage:
            effect_owner.health -= damage

        effect_owner.apply_noise_shake(4.0)

        attack_sfx_player.pitch_scale = randf_range(0.9, 1.1)
        attack_sfx_player.play()

        effect_owner.velocity += Vector2.RIGHT.rotated(deg_to_rad(randf_range(0, 360))) * 64

        effect_owner.modulate = Color.PALE_GREEN

        if tween and tween.is_running():
            tween.kill()

        tween = create_tween()
        tween.set_trans(Tween.TRANS_SINE)
        tween.set_ease(Tween.EASE_IN_OUT)
        tween.tween_property(effect_owner, "modulate", Color.WHITE, 0.5)

        hit += 1
        time_since_last_hit = 0

func expire_effect() -> void:
    if effect_owner:
        effect_owner.effects.erase(self)

    queue_free()
