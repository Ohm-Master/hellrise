extends Node2D

class_name HealthComponet

signal health_changed(currenthp : float, maxhp : float)

@export var max_health : float
var health : float

func _ready() -> void:
	health = max_health
	
func take_damage(damage : float):
	health -= damage
	
	if health <= 0:
		get_parent().die()
		
	health_changed.emit(health, max_health)
