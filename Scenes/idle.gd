extends State

@export var fall_state : State
@export var move_state : State
@export var jump_state : State

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump"):
		return jump_state
	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
		return move_state 
	return null

func process_physics(delta: float) -> State:
	parent.velocity.x = move_toward(parent.velocity.x, 0, move_speed / 9)
	
	if not $Player.is_on_floor():
		return fall_state
	return null 
	
