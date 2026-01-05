extends Node2D
#52 -8
const BULLET : PackedScene = preload("uid://d1kqj34jeqaf")

@onready var shoot_point: Marker2D = $Pivot_point/Pistol/Shoot_point

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if get_global_mouse_position().x < global_position.x:
		$Pivot_point/Pistol.flip_v = true
		shoot_point.position = Vector2(52, 8)
	else:
		$Pivot_point/Pistol.flip_v = false
		shoot_point.position = Vector2(52, -8)
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Shoot"):
		var bullet = BULLET.instantiate()
		
		bullet.position = shoot_point.global_position
		bullet.rotation = shoot_point.global_rotation
		
		get_tree().current_scene.add_child(bullet)
	
