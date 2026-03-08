extends Character
class_name EnemyCharacter

signal died

@onready var nav_agent = $NavigationAgent2D
@onready var nav_timer = $NavigationTimer
@onready var fsm = $FiniteStateMachine

@onready var player = get_tree().current_scene.get_node("Player")

var should_check_player = true
var should_chase_player = false

func _ready() -> void:
	max_speed /= 4
	
	get_parent().get_parent().register_enemy(self)

func _process(_delta: float) -> void:
	if should_check_player:
		if player.current_room_slot_id == current_room_slot_id:
			should_check_player = false
			should_chase_player = true
		else:
			should_chase_player = false
	
	if fsm.state == fsm.states.chase:
		var player_direction = (player.global_position - global_position).normalized()
		
		if player_direction.x > 0 and body_sprite.flip_h:
			body_sprite.flip_h = false
		
		if player_direction.x < 0 and not body_sprite.flip_h:
			body_sprite.flip_h = true

func _get_path_to_player() -> void:
	nav_agent.target_position = player.position

func _on_navigation_timer_timeout() -> void:
	if should_chase_player:
		fsm.set_state(fsm.states.chase)
		_get_path_to_player()
	else:
		fsm.set_state(fsm.states.idle)
		direction = lerp(direction, Vector2.ZERO, friction)

func chase() -> void:
	direction = (nav_agent.get_next_path_position() - global_position).normalized()

func die():
	died.emit()
	queue_free()
