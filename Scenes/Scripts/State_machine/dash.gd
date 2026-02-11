extends State

class_name Dash

@export var fall_state : State
@export var idle_state : State
@export var move_state : State
@export var slide_state : State

var is_good_dash := true

func enter() -> void:
	parent.dash_timer = parent.dash_time
	parent.can_dash = false
	parent.dashing = true
	
	match parent.dash_direction:
		parent.DIR.UP:
			if parent.can_air_dash():
				parent.air_dashes -= 1
				parent.velocity.y = -parent.dash_speed
			else:
				is_good_dash = false
		parent.DIR.DOWN:
			if parent.can_air_dash():
				parent.air_dashes -= 1
				parent.velocity.y = parent.dash_speed
			else:
				is_good_dash = false
		parent.DIR.RIGHT:
			if parent.is_on_floor():
				parent.velocity.x = parent.dash_speed
			else:
				if parent.can_air_dash():
					parent.velocity.x = parent.dash_speed
					parent.air_dashes -= 1
				else:
					is_good_dash = false
		parent.DIR.LEFT:
			if parent.is_on_floor():
				parent.velocity.x = -parent.dash_speed
			else:
				if parent.can_air_dash():
					parent.velocity.x = -parent.dash_speed
					parent.air_dashes -= 1
				else:
					is_good_dash = false

	parent.dash_cooldown_timer = parent.dash_cooldown

func process_physics(delta: float) -> State:
	if parent.dash_timer <= 0 or not is_good_dash:
		return calculate_end_state()
	
	parent.dash_timer -= delta
	
	if parent.dash_direction == parent.DIR.UP:
		parent.velocity.y = move_toward(parent.velocity.y, -1000, 15000 * delta)
	
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
	is_good_dash = true
