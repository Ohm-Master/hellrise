extends Node2D

class_name Gun

@export var BULLET : PackedScene
@export var ray_cast : RayCast2D
@export var shoot_point: Marker2D
@export var sprite : Sprite2D

@export var damage : float
@export var cooldown : float
var cooldown_timer : float
var can_shoot : bool

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	ray_cast.force_raycast_update()
	
	can_shoot = cooldown_timer <= 0 and not ray_cast.is_colliding()

	cooldown_timer -= delta
	
	if get_global_mouse_position().x < global_position.x:
		sprite.flip_v = true
		shoot_point.position.y = abs(shoot_point.position.y)
	else:
		sprite.flip_v = false
		shoot_point.position.y = -abs(shoot_point.position.y)

func shoot():
	if not can_shoot: return
	
	cooldown_timer = cooldown
	
	var bullet = BULLET.instantiate()
	
	bullet.position = shoot_point.global_position
	bullet.rotation = shoot_point.global_rotation
	bullet.damage = damage
	
	get_tree().current_scene.add_child(bullet)
	
