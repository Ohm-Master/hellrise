extends State

class_name Wall_grab_state

@export var idle_state : State
@export var jump_state : State
@export var fall_state : State

func enter() -> void:
	parent.velocity.y = parent.FRICTION

func process_physics(delta: float) -> State:
	if parent.is_on_left_wall_only():
		if Input.is_action_pressed("Left"):
			parent.velocity.y = 0
		elif Input.is_action_pressed("Right"):
			return fall_state
		else:
			parent.velocity.y = parent.FRICTION
	if parent.is_on_left_wall_only():
		if Input.is_action_pressed("Rght"):
			parent.velocity.y = 0
		elif Input.is_action_pressed("Left"):
			return fall_state
		else:
			parent.velocity.y = parent.FRICTION
	
	
	if not parent.is_on_wall_only():
		if parent.is_on_floor():
			return idle_state
		elif parent.is_on_ceiling():
			return null
		else:
			return fall_state
	return null
