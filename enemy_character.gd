extends Character
class_name EnemyCharacter

@onready var nav_agent = $NavigationAgent2D
@onready var nav_timer = $NavigationTimer
@onready var fsm = $FiniteStateMachine

@onready var player = get_tree().current_scene.get_node("Player")

func _ready() -> void:
	max_speed /= 4

func _process(_delta: float) -> void:
	var player_direction = (player.global_position - global_position).normalized()
	
	if fsm.state == fsm.states.chasing:
		if player_direction.x > 0 and sprite.flip_h:
			sprite.flip_h = false
		
		if player_direction.x < 0 and not sprite.flip_h:
			sprite.flip_h = true

func _get_path_to_player() -> void:
	nav_agent.target_position = player.position

func chase() -> void:
	if not nav_agent.is_target_reached():
		direction = (nav_agent.get_next_path_position() - global_position).normalized()

func _on_navigation_timer_timeout() -> void:
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		nav_timer.stop()
		direction = lerp(direction, Vector2.ZERO, friction)
