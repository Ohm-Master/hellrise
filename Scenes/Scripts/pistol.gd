extends Gun

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Shoot"):
		shoot()
		print(shoot_point.position.y)
