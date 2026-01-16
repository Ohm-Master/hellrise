extends Node2D

class_name HealthComponet

signal health_changed(currenthp : float, maxhp : float)

const DAMAGE_NUMBER = preload("uid://cwakok6ey7g6w")

@export var max_health : float
var health : float

func _ready() -> void:
	health = max_health
	randomize()

func take_damage(damage : float):
	var was_killed := false
	
	if damage >= health:
		was_killed = true
	else:
		was_killed = false
	health -= damage

		
	var dmg_num = DAMAGE_NUMBER.instantiate()
	dmg_num.position = global_position + Vector2(randf_range(-100, 0), -100 + randf_range(-30, -0))
	dmg_num.setup(damage, was_killed)
	get_tree().current_scene.add_child(dmg_num)

	if health <= 0:
		get_parent().die()
		
	health_changed.emit(health, max_health)
