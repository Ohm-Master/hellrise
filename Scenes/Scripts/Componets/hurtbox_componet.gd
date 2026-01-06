extends Area2D

class_name HurtBoxComponet

@export var Health : HealthComponet

func damage(amount : float):
	Health.take_damage(amount)
