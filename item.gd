extends Node2D
class_name Item

@onready var item_particles = $ItemParticles
@onready var sprite = $Sprite
@onready var hitbox = $Hitbox
@onready var pickup_sfx_player = $PickupSFXPlayer
@onready var use_sfx_player = $UseSFXPlayer

@export var item_name: String
@export var item_description: String
@export var item_tier: int
@export var item_price: int = -1

@export var is_rotating = true
@export var can_be_picked_up = true

var item_owner: Player

var tween: Tween

func _ready() -> void:
    item_tier = clamp(item_tier, 0, 4)

    if item_price == -1:
        item_price = round(10 * (item_tier + 1) * randf_range(0.75, 1.25))

    if tween and tween.is_running():
        tween.kill()

    sprite.self_modulate = Color.TRANSPARENT

    tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.25)

func _process(delta: float) -> void:
    if is_rotating:
        rotate(delta)

    if item_owner:
        global_position = global_position.move_toward(
            item_owner.item_slot.global_position + item_owner.item_slot.global_transform.x * 32,
            32.0 * delta
        )

func _on_hitbox_body_entered(body: Node2D) -> void:
    if can_be_picked_up:
        if body is Player and not body.item:
            pickup(body)

func pickup(body: Node2D) -> void:
    can_be_picked_up = false

    item_owner = body
    item_owner.item = self

    pickup_sfx_player.pitch_scale = randf_range(0.9, 1.1)
    pickup_sfx_player.play()

    if get_parent():
        call_deferred("reparent", item_owner.item_slot)
    else:
        item_owner.item_slot.call_deferred("add_child", self)

    global_position = item_owner.item_slot.global_position

func drop() -> void:
    can_be_picked_up = true

    item_owner.item = null
    item_owner = null

    call_deferred("reparent", Game.world.get_node("ItemsContainer"))

func use() -> void:
    if not Game.player.cheats_enabled:
        Game.data["total_points_earned"] += 1 * Game.player.points_multi
        Game.data["total_items_used"] += 1

    Game.player.run_items_used += 1
    Game.player.floor_items_used += 1

    Game.player.run_score += 10
    Game.player.run_points += 1 * Game.player.points_multi
    Game.player.run_points_earned += 1 * Game.player.points_multi

    can_be_picked_up = false

    item_owner.item = null
    item_owner = null

    use_sfx_player.pitch_scale = randf_range(0.9, 1.1)
    use_sfx_player.play()

    call_deferred("reparent", Game.world.get_node("ItemsContainer"))

    item_particles.emitting = false

    if tween and tween.is_running():
        tween.kill()

    tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 0.25)

    await use_sfx_player.finished

    queue_free()
