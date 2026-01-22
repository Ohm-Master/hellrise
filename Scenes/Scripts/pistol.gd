extends Node2D

const BULLET : PackedScene = preload("uid://d1kqj34jeqaf")

@onready var shoot_point: Marker2D = $Pivot_point/Pistol/Shoot_point
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var damage := 10.0
var can_shoot := true
var cooldown := 0.3
var cooldown_timer := 0.0

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	
	if cooldown_timer <= 0:
		if !ray_cast_2d.is_colliding():
			can_shoot = true
	else:
		can_shoot = false
		
	cooldown_timer -= delta
	if get_global_mouse_position().x < global_position.x:
		$Pivot_point/Pistol.flip_v = true
		shoot_point.position = Vector2(30, 8)
	else:
		$Pivot_point/Pistol.flip_v = false
		shoot_point.position = Vector2(30, -8)
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Shoot") and can_shoot:
		cooldown_timer = cooldown
		var bullet = BULLET.instantiate()
		
		bullet.position = shoot_point.global_position
		bullet.rotation = shoot_point.global_rotation
		bullet.damage = damage
		
		get_tree().current_scene.add_child(bullet)
	else:
		return
