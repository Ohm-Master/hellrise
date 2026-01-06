extends State

@export var move_state : State
@export var idle_state : State
@export var double_jump_state : State

func enter() -> void:
	super()
	parent.velocity.y = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump") and parent.can_double_jump:
		return double_jump_state
	return null


func process_physics(delta: float) -> State:
	var movement := Input.get_axis("Left","Right") * move_speed
	parent.velocity.x = movement
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		else:
			return idle_state
	return null
