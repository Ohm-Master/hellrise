extends Node2D

class_name HurtBox

@export var damage : float
var parent
var the_owner : String

var has_hit := false

func _on_area_entered(area: Area2D) -> void:
	if has_hit:
		return

	if area == parent:
		return

	elif area.is_in_group("Damageable"):
		if has_hit:
			return
		area.hitbox_parent = the_owner
		area.damage(damage)
		if has_hit:
			return
		has_hit = true
		get_parent().queue_free()
		return
