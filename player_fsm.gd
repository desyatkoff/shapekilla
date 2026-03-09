extends FiniteStateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("dead")

func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	if state != states.dead:
		get_parent().get_input()
		get_parent().move()

func _get_transition() -> int:
	match state:
		states.idle:
			if get_parent().velocity.length() > 1:
				return states.move
		states.move:
			if get_parent().velocity.length() < 1:
				return states.idle
	
	return -1
