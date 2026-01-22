extends Area2D

class_name HurtBoxComponet

@export var Health : HealthComponet

var parent : String
var hitbox_parent : String

func damage(amount : float):
	if parent and parent == hitbox_parent:
		Health.take_damage(amount / 10)
		return
	Health.take_damage(amount)
