extends Node2D
class_name Item

@onready var sprite = $Sprite
@onready var hitbox = $Hitbox
@onready var item_particles = $ItemParticles

@export var is_rotating = true

var item_owner: Player

var tween: Tween

func _ready() -> void:
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
	if body is Player and not body.item:
		item_owner = body
		item_owner.item = self
		
		call_deferred("reparent", body.item_slot)

func drop() -> void:
	item_owner.item = null
	item_owner = null
	
	call_deferred("reparent", Game.world.get_node("ItemsContainer"))

func use() -> void:
	item_owner.item = null
	item_owner = null
	
	call_deferred("reparent", Game.world.get_node("ItemsContainer"))
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 0.25)
	tween.finished.connect(queue_free)
