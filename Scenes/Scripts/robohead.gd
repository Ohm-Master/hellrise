extends CharacterBody2D

#TODO:
#fix bullet
#Fox anims
#Add death anim

@export var player : CharacterBody2D
const BULLET = preload("uid://d1kqj34jeqaf")
@onready var shoot_point: Marker2D = $Shootpoint

enum States {
	IDLE,
	CHASE,
	SHOOT, 
}

var state = States.IDLE

var in_chase_zone := false
var in_shoot_zone := false

var move_speed := 600
var damage := 20.0

func _physics_process(delta: float) -> void:
	handle_states(delta)
	move_and_slide()

func handle_states(_delta : float):
	match state:
		States.IDLE:
			idle_state()
		States.CHASE:
			chase_state()
		States.SHOOT:
			shoot_state()
			
func idle_state():
	velocity = Vector2(0,0)
	
	if in_chase_zone == true:
		state = States.CHASE
	
func chase_state():
	look_at(player.global_position)
	
	var direction := global_position.direction_to(player.global_position)
	velocity = direction * move_speed
	
	if not in_chase_zone:
		state = States.IDLE
	if in_shoot_zone == true:
		state = States.SHOOT
	
func shoot_state():
	velocity = Vector2(0,0)
	var bullet = BULLET.instantiate()
	
	bullet.position = shoot_point.global_position
	bullet.rotation = shoot_point.global_rotation
	bullet.damage = damage
	
	get_tree().current_scene.add_child(bullet)
	
func _on_chase_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_chase_zone = true

func _on_chase_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_chase_zone = false

func _on_shoot_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_shoot_zone = true

func _on_shoot_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_shoot_zone = false
