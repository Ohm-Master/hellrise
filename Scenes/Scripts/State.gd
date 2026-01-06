extends Node

class_name State

var parent : Player

var move_speed : float = parent.move_speed
var gravity : float = parent.gravity
var jump_force : = parent.jump_force

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
