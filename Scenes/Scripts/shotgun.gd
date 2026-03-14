extends Gun

func _physics_process(delta: float) -> void:
	if get_global_mouse_position().x < global_position.x:
		shoot_point.position.y = abs(shoot_point.position.y)
	else:
		shoot_point.position.y = -abs(shoot_point.position.y)

func shoot():
	var bullet = BULLET.instantiate()
	
	bullet.position = shoot_point.global_position
	bullet.rotation = shoot_point.global_rotation
	bullet.damage = bullet_damage
	bullet.speed = bullet_speed
	
	get_tree().current_scene.add_child(bullet)
	
	for i in range(6):
		var angles = [-15, -10, -5, 5, 10, 15]
		
		var bulleti = BULLET.instantiate()
		
		bulleti.position = shoot_point.global_position
		bulleti.rotation = shoot_point.global_rotation + deg_to_rad(angles[i])
		bulleti.damage = bullet_damage
		bulleti.speed = bullet_speed
		
		get_tree().current_scene.add_child(bulleti)
	
