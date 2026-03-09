extends Character
class_name EnemyCharacter

signal died

@onready var nav_agent = $NavigationAgent2D
@onready var nav_timer = $NavigationTimer

@onready var player = get_tree().current_scene.get_node("Player")

var should_check_player = true
var should_chase_player = false

func _ready() -> void:
	max_speed /= 4
	
	get_parent().get_parent().register_enemy(self)

func _process(_delta: float) -> void:
	health = clamp(health, 0, max_health)
	
	if health == 0 and fsm.state != fsm.states.dead:
		die()
	
	if should_check_player and is_instance_valid(player):
		if player.current_room_slot_id == current_room_slot_id:
			should_check_player = false
			should_chase_player = true
		else:
			should_chase_player = false
	
	if fsm.state == fsm.states.chase and is_instance_valid(player):
		var player_direction = (player.global_position - global_position).normalized()
		
		if player_direction.x > 0 and body_sprite.flip_h:
			body_sprite.flip_h = false
		
		if player_direction.x < 0 and not body_sprite.flip_h:
			body_sprite.flip_h = true

func _get_path_to_player() -> void:
	if fsm.state == fsm.states.chase and player.fsm.state != player.fsm.states.dead:
		nav_agent.target_position = player.position
	else:
		nav_agent.target_position = position

func _on_navigation_timer_timeout() -> void:
	if should_chase_player:
		fsm.set_state(fsm.states.chase)
		_get_path_to_player()
	else:
		if fsm.state != fsm.states.dead:
			fsm.set_state(fsm.states.idle)
			direction = lerp(direction, Vector2.ZERO, friction)

func chase() -> void:
	direction = (nav_agent.get_next_path_position() - global_position).normalized()

func die() -> void:
	fsm.set_state(fsm.states.dead)
	died.emit()
	should_chase_player = false
	body_sprite.region_rect = Rect2(32.0, 0.0, 32.0, 32.0)
	set_collision_layer_value(3, false)
