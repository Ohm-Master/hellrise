extends State

class_name Wall_jump_state

@export var fall_state : State
@export var double_jump_state : State
@export var wall_grab_state : State

var can_move := false
var move_timer := 0.25

func enter() -> void:
	if parent.wall_jump_direction == parent.DIR.RIGHT:
		parent.position.x += 5
	if parent.wall_jump_direction == parent.DIR.LEFT:
		parent.position.x -= 5
	
	parent.velocity.y = parent.jump_force
	
	can_move = false
	move_timer = 0.25

func process_physics(delta: float) -> State:
	move_timer -= delta
	can_move = move_timer <= 0
	print(can_move, move_timer)
	if can_move:
		if Input.is_action_pressed("Left"):
			parent.velocity.x = -parent.air_speed
		elif Input.is_action_pressed("Right"):
			parent.velocity.x = parent.air_speed
		else:
			parent.velocity.x = 0
	else:
		if parent.wall_jump_direction == parent.DIR.RIGHT:
			parent.velocity.x = parent.move_speed
		if parent.wall_jump_direction == parent.DIR.LEFT:
			parent.velocity.x = -parent.move_speed
	
	if parent.is_touching_wall_only():
		return wall_grab_state
	elif parent.velocity.y >= 0:
		return fall_state
	
	return null

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump"):
		return double_jump_state
	return null
