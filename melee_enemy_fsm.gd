extends FiniteStateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("chasing")

func _ready() -> void:
	set_state(states.chasing)

func _state_logic(_delta: float) -> void:
	match state:
		states.chasing:
			get_parent().chase()
			get_parent().move()
