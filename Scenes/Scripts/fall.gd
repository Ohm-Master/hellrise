extends State

@export var move_state : State
@export var idle_state : State

func enter() -> void:
	super()
	parent.velocity.y = 0
	
func process_physics(delta: float) -> State:
	var movement := Input.get_axis("Left","Right") * move_speed
	parent.velocity.x = movement
	return null
