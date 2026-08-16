extends Projectile
class_name StoneProjectile

@onready var sprite = $Sprite

func _ready() -> void:
    lifetime_timer.queue_free()

func _process(delta: float) -> void:
    move_local_x(speed * delta)
    sprite.rotation += delta * 4
