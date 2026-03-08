extends FiniteStateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("chase")

func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	match state:
		states.chase:
			get_parent().chase()
			get_parent().move()
