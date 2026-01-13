extends State

@export var move_state : State
@export var idle_state : State
@export var double_jump_state : State

func enter() -> void:
	parent.velocity.y = 0

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump") and parent.can_double_jump:
		return double_jump_state
	return null


func process_physics(_delta: float) -> State:
	
	if Input.is_action_pressed("Left"):
		parent.velocity.x = -move_speed
	elif Input.is_action_pressed("Right"):
		parent.velocity.x = move_speed
	else:
		parent.velocity.x = 0
		
	if parent.is_on_floor():
		if parent.velocity.x != 0:
			return move_state
		else:
			return idle_state
	return null
