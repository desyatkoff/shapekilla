extends FiniteStateMachine

func _init() -> void:
    _add_state("IDLE")
    _add_state("CHASE")
    _add_state("ATTACK")
    _add_state("DEAD")

func _ready() -> void:
    set_state(states.IDLE)

func _state_logic(_delta: float) -> void:
    match state:
        states.CHASE:
            get_parent().chase()
            get_parent().move()
