extends State

class_name Move_state

@export var fall_state : State
@export var idle_state : State
@export var jump_state : State
@export var slide_state : State

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Slide"):
		return slide_state
	if Input.is_action_just_pressed("Jump"):
		return jump_state
	return null

func process_physics(_delta: float) -> State:
	
	if Input.is_action_pressed("Left"):
		parent.velocity.x = -parent.move_speed
	elif Input.is_action_pressed("Right"):
		parent.velocity.x = parent.move_speed
	else:
		return idle_state
		
	if parent.velocity.x == 0:
		return idle_state
	if not parent.is_on_floor():
		return fall_state
	
	return null
	
