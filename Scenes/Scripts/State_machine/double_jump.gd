extends State

class_name Double_jump_state

@export var fall_state : State

func enter() -> void:
	parent.velocity.y = jump_force
	parent.add_smoke()
	parent.can_double_jump = false
	
func process_physics(delta: float) -> State:
	if Input.is_action_pressed("Left"):
		parent.velocity.x = -move_speed
	elif Input.is_action_pressed("Right"):
		parent.velocity.x = move_speed
	else:
		if last_state is Slide_state:
			parent.velocity.x = parent.slide_speed
		else:
			parent.velocity.x = move_toward(parent.velocity.x, 0, parent.air_drag * delta)
		
	if parent.velocity.y > 0:
		return fall_state
	return null
