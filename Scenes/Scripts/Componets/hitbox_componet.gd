extends Node2D

class_name HurtBox

@export var damage : float
var parent

var has_hit := false

func _on_area_entered(area: Area2D) -> void:
	if has_hit:
		return

	if area == parent:
		return

	elif area.is_in_group("Damageable"):
		area.damage(damage)
		has_hit = true
		get_parent().queue_free()
