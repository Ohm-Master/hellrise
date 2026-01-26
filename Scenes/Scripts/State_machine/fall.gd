extends State

class_name Fall_state

@export var move_state : State
@export var idle_state : State
@export var double_jump_state : State
@export var jump_state : State
@export var wall_grab_state : State

func enter() -> void:
	parent.velocity.y = 0

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump") and parent.can_double_jump:
		return double_jump_state
	return null


func process_physics(delta: float) -> State:
	
	if last_state is Jump_state or last_state is Double_jump_state:
		parent.velocity.y += parent.gravity / 2 * delta
	
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
		
	if parent.is_on_floor():
		if parent.velocity.x != 0:
			return move_state
		else:
			return idle_state
	if parent.is_touching_wall_only():
		return wall_grab_state
	
	return null
