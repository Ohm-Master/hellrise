extends State

class_name Jump_state

@export var fall_state : State
@export var double_jump_state : State

#var air_time : float = 0.0 (it equals 0.55)

func enter() -> void:
	parent.velocity.y = jump_force
#	air_time = 0.0

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump") and parent.can_double_jump:
		return double_jump_state
	return null

func process_physics(delta: float) -> State:
#	air_time += delta
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
#		print(air_time)
		return fall_state
	return null
