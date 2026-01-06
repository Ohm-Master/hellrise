extends Node

class_name State

var parent : Player

var move_speed : float = 700.0
var gravity : float = 1500.0
var jump_force : float = -750.0 

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
