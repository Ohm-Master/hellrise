extends State

class_name Jump_state

@export var fall_state : State
@export var double_jump_state : State

func enter() -> void:
	parent.velocity.y = jump_force

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump") and parent.can_double_jump:
		return double_jump_state
	return null

func process_physics(delta: float) -> State:

	if Input.is_action_pressed("Left"):
		parent.velocity.x = -move_speed
	elif Input.is_action_pressed("Right"):
		parent.velocity.x = move_speed
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.air_drag * delta)

	
	if parent.velocity.y > 0:
		return fall_state
	return null
