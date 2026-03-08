extends FiniteStateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("moving")

func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	get_parent().get_input()
	get_parent().move()

func _get_transition() -> int:
	match state:
		states.idle:
			if get_parent().velocity.length() > 1:
				return states.moving
		states.moving:
			if get_parent().velocity.length() < 1:
				return states.idle
	
	return -1

func _enter_state(_prev_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			pass
		states.moving:
			pass

func _exit_state(_state_exited: int) -> void:
	pass
