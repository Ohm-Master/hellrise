extends State

class_name Slide_state

@export var fall_state : State
@export var idle_state : State
@export var move_state : State
@export var jump_state : State
@export var double_jump_state : State

func enter() -> void:
	parent.disable_collision()
	parent.enable_slide_collision()
	
	parent.is_sliding = true
	if parent.direction == parent.DIR.RIGHT:
		parent.velocity.x = parent.slide_speed
	elif parent.direction == parent. DIR.LEFT:
		parent.velocity.x = -parent.slide_speed

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump"):
		if parent.is_on_floor():
			return jump_state
		else:
			return double_jump_state
	elif Input.is_action_just_released("Slide"):
		parent.is_sliding = false
		if parent.is_on_floor():
			var movement := Input.get_axis("Left", "Right")
			if movement:
				return move_state
			else:
				return idle_state
		elif not parent.is_on_floor():
				return fall_state
	return null

func exit() -> void:
	parent.disable_slide_collision()
	parent.enable_collision()
