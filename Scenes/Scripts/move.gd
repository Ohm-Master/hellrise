extends State

@export var fall_state : State
@export var idle_state : State
@export var jump_state : State

func enter() -> void:
	super()
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("Jump"):
		return jump_state
	return null

func process_physics(delta: float) -> State:
	var movement := Input.get_axis("Left", "Right") * move_speed
	parent.velocity.x = movement
	if !movement:
		return idle_state
	if not parent.is_on_floor():
		return fall_state
	
	return null
	
