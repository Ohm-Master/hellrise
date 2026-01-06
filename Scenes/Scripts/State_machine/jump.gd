extends State

@export var fall_state : State
@export var double_jump_state : State

func enter() -> void:
	super()
	parent.velocity.y = jump_force

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump") and parent.can_double_jump:
		return double_jump_state
	return null

func process_physics(delta: float) -> State:
	var movement := Input.get_axis("Left", "Right") * move_speed
	parent.velocity.x = movement
	
	if parent.velocity.y > 0:
		return fall_state
	return null
