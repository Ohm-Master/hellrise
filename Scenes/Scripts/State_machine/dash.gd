extends State

class_name Dash

@export var idle_state : State

func enter() -> void:
	parent.dash_cooldown_timer = parent.dash_cooldown
	parent.dash_timer = parent.dash_time
	parent.can_dash = false
	parent.dashing = true
	
func process_physics(delta: float) -> State:
	
	match parent.dash_direction:
		parent.DIR.UP:
			parent.velocity.y = move_toward(parent.velocity.y, -parent.dash_speed,  60000 * delta)
		parent.DIR.DOWN:
			parent.velocity.y = move_toward(parent.velocity.y, parent.dash_speed, 90000 * delta)
		parent.DIR.RIGHT:
			parent.velocity.x = move_toward(parent.velocity.x, parent.dash_speed, 180000 * delta)
		parent.DIR.LEFT:
			parent.velocity.x = move_toward(parent.velocity.x, -parent.dash_speed, 180000 * delta)
	
	parent.dash_timer -= delta
	
	if parent.dash_timer <= 0:
		return idle_state
	return null

func exit() -> void:
	parent.dashing = false
