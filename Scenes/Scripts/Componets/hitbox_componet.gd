extends Node2D

class_name HurtBox

@export var damage : float
var parent

func _on_area_entered(area: Area2D) -> void:
	if area == parent:
		return
	elif area.is_in_group("Damageable"):
		area.damage(damage)
		get_parent().queue_free()
