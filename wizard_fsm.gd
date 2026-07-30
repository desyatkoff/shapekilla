extends FiniteStateMachine

func _init() -> void:
    _add_state("IDLE")
    _add_state("DEAD")

func _ready() -> void:
    set_state(states.IDLE)
