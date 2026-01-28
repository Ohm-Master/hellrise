extends State

class_name Wall_grab_state

@export var idle_state : State
@export var wall_jump_state : State
@export var fall_state : State

func process_physics(delta: float) -> State:
	if parent.is_on_left_wall_only():
		
		if Input.is_action_pressed("Left"):
			parent.velocity.y = 0
			
		if Input.is_action_pressed("Jump"):
			parent.wall_jump_direction = parent.DIR.RIGHT
			return wall_jump_state
			
		elif Input.is_action_pressed("Right"):
			return fall_state
			
		else:
			parent.velocity.y += parent.FRICTION * delta

	if parent.is_on_right_wall_only():
		
		if Input.is_action_pressed("Right"):
			parent.velocity.y = 0
			
		elif Input.is_action_pressed("Jump"):
			parent.wall_jump_direction = parent.DIR.LEFT
			return wall_jump_state
			
		elif Input.is_action_pressed("Left"):
			return fall_state
			
		else:
			parent.velocity.y += parent.FRICTION * delta
	
	if not parent.is_touching_wall_only():
		if parent.is_on_floor():
			return idle_state
		elif parent.is_on_ceiling():
			return null
		else:
			return fall_state
	return null
