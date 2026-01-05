extends Node

class_name State

@export var move_speed : float = 700.0 
@export var gravity : float = 1500.0

var parent = Player

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
