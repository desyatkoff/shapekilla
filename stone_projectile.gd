extends Projectile
class_name StoneProjectile

func _ready():
    lifetime_timer.queue_free()
