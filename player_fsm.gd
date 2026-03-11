extends FiniteStateMachine

func _init() -> void:
	_add_state("IDLE")
	_add_state("MOVE")
	_add_state("ATTACK")
	_add_state("DEAD")

func _ready() -> void:
	set_state(states.IDLE)

func _state_logic(_delta: float) -> void:
	if state != states.DEAD:
		get_parent().get_input()
		get_parent().move()

func _get_transition() -> int:
	match state:
		states.IDLE:
			if get_parent().velocity.length() > 1:
				return states.MOVE
		states.MOVE:
			if get_parent().velocity.length() < 1:
				return states.IDLE
	
	return -1
