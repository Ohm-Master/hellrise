extends State

class_name Double_jump_state

@export var fall_state : State

func enter() -> void:
	super()
	parent.velocity.y = jump_force
	parent.add_smoke()
	parent.can_double_jump = false
	
func process_physics(delta: float) -> State:
	var movement := Input.get_axis("Left", "Right") * move_speed
	parent.velocity.x = movement
	
	if parent.velocity.y > 0:
		return fall_state
	return null
