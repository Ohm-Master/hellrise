extends Node2D

class_name HealthComponet

signal health_changed(currenthp : float, maxhp : float)

const DAMAGE_NUMBER = preload("uid://cwakok6ey7g6w")

@export var max_health : float
var health : float

func _ready() -> void:
	health = max_health
	
func take_damage(damage : float):
	health -= damage
	var dmg_num = DAMAGE_NUMBER.instantiate()
	dmg_num.position = get_parent().global_position
	dmg_num.setup(damage)
	get_tree().current_scene.add_child(dmg_num)

	if health <= 0:
		get_parent().die()
		
	health_changed.emit(health, max_health)
