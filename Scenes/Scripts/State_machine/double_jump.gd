extends State

class_name Double_jump_state

@export var fall_state : State
@export var wall_grab_state : State

func enter() -> void:
	parent.velocity.y = jump_force
	parent.add_smoke()
	parent.can_double_jump = false
	
func process_physics(delta: float) -> State:
	if Input.is_action_pressed("Left"):
		parent.velocity.x = -parent.air_speed
		parent.is_sliding = false
	elif Input.is_action_pressed("Right"):
		parent.velocity.x = parent.air_speed
		parent.is_sliding = false
	else:
		if Input.is_action_just_released("Slide"):
			parent.velocity.x = move_toward(parent.velocity.x, 0, parent.air_drag * delta)
			parent.is_sliding = false
		elif Input.is_action_pressed("Slide") and parent.is_sliding:
			if parent.direction == parent.DIR.RIGHT:
				parent.velocity.x = parent.slide_speed
			else:
				parent.velocity.x = -parent.slide_speed
		else:
			parent.velocity.x = 0
	if parent.velocity.y > 0:
		return fall_state
	if parent.is_touching_wall_only():
		return wall_grab_state
		
	return null
