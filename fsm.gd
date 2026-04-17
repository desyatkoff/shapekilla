extends Node
class_name FiniteStateMachine

var states = {}

var previous_state = -1
var state = -1

func _physics_process(delta: float) -> void:
    if state != -1:
        _state_logic(delta)

        var transition = _get_transition()

        if transition != -1:
            set_state(transition)

func _state_logic(_delta: float) -> void:
    pass

func _get_transition() -> int:
    return -1

func _add_state(new_state: String) -> void:
    states[new_state] = states.size()

func _enter_state(_prev_state: int, _new_state: int) -> void:
    pass

func _exit_state(_state_exited: int) -> void:
    pass

func set_state(new_state: int) -> void:
    _exit_state(state)

    previous_state = state
    state = new_state

    _enter_state(previous_state, state)
