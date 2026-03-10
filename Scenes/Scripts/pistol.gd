extends Gun

@onready var shoot_point: Marker2D = $Pivot_point/Pistol/Shoot_point

func shoot():
	super.shoot()
	
	var bullet = BULLET.instantiate()
	
	bullet.position = shoot_point.global_position
	bullet.rotation = shoot_point.global_rotation
	bullet.damage = damage
	
	get_tree().current_scene.add_child(bullet)
	
