extends Node2D

class_name Gun

@export var BULLET : PackedScene
@export var ray_cast : RayCast2D
@export var sprite : Sprite2D

@export var damage : float
@export var cooldown : float
var cooldown_timer := 0.0
var can_shoot := false

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	ray_cast.force_raycast_update()
	
	cooldown_timer -= delta
	
	can_shoot = cooldown_timer <= 0 and not ray_cast.is_colliding()
	
	if get_global_mouse_position().x < global_position.x:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Shoot") and can_shoot:
		shoot()
	

func shoot():
	cooldown_timer = cooldown
	
