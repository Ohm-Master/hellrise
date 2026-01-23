extends State

class_name Idle_state

@export var fall_state : State
@export var move_state : State
@export var jump_state : State
@export var slide_state: State

func process_input(_event: InputEvent) -> State:
	if Input.is_action_pressed("Jump"):
		return jump_state
	if Input.is_action_pressed("Slide"):
		return slide_state
	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
		return move_state 
	return null

func process_physics(_delta: float) -> State:
	if parent.has_buffered_jump():
		return jump_state
	
	parent.velocity.x = move_toward(parent.velocity.x, 0, move_speed / 2)
	
	if not parent.is_on_floor():
		return fall_state
	return null 
	
