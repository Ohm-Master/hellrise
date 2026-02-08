extends State

class_name Dash

@export var fall_state : State
@export var idle_state : State
@export var move_state : State
@export var slide_state : State

func enter() -> void:
	parent.dash_cooldown_timer = parent.dash_cooldown
	parent.dash_timer = parent.dash_time
	parent.can_dash = false
	parent.dashing = true
	
func process_physics(delta: float) -> State:
	
	match parent.dash_direction:
		parent.DIR.UP:
			parent.velocity.y = move_toward(parent.velocity.y, -parent.dash_speed,  180000 * delta)
		parent.DIR.DOWN:
			parent.velocity.y = move_toward(parent.velocity.y, parent.dash_speed, 180000 * delta)
		parent.DIR.RIGHT:
			parent.velocity.x = move_toward(parent.velocity.x, parent.dash_speed, 180000 * delta)
		parent.DIR.LEFT:
			parent.velocity.x = move_toward(parent.velocity.x, -parent.dash_speed, 180000 * delta)
	
	parent.dash_timer -= delta
	
	if parent.dash_timer <= 0:
		return calculate_end_state()
	return null

func calculate_end_state() -> State:
	var movement = Input.get_axis("Left","Right")
	if parent.is_on_floor():
		if  Input.is_action_pressed("Slide"):
			return slide_state
		elif movement:
			return move_state
		else:
			return idle_state 
	else:
		return fall_state

func exit() -> void:
	parent.dashing = false
