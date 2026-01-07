extends CharacterBody2D

#TODO:
#Add anims
#Add death anim

const BULLET = preload("uid://d1kqj34jeqaf")

@onready var sprite: Sprite2D = $Sprite
@onready var shoot_point: Marker2D = $Shootpoint
@export var player : CharacterBody2D

enum States {
	IDLE,
	CHASE,
	SHOOT, 
}

var state = States.IDLE

var in_chase_zone := false
var in_shoot_zone := false
var damage_taken := false

var move_speed := 600
var damage := 20.0
var shoot_cooldown := 1.0
var shoot_timer := 1.0

var bob_time := 0.0
var bob_speed := 5.0
var bob_height := 10.0

func _ready():
	shoot_timer = 0

func _physics_process(delta: float) -> void:
	handle_states(delta)
	move_and_slide()

func handle_states(delta : float):
	match state:
		States.IDLE:
			idle_state(delta)
		States.CHASE:
			chase_state()
		States.SHOOT:
			shoot_state(delta)
			
func idle_state(delta : float):
	velocity = Vector2(0,0)
	
	bob_time += delta * bob_speed
	sprite.position.x = sin(bob_time) * bob_height
	
	rotation_degrees = 90
	#if in_chase_zone or damage_taken:
	#	state = States.CHASE
	
func chase_state():
	look_at(player.global_position)
	
	var direction := global_position.direction_to(player.global_position)
	velocity = direction * move_speed
	
	if not in_chase_zone and not damage_taken:
		state = States.IDLE
	if in_shoot_zone == true:
		state = States.SHOOT
	
func shoot_state(delta : float):
	if player:
		look_at(player.global_position)
	velocity = Vector2(0,0)
	
	if shoot_timer <= 0:
		shoot()
		shoot_timer = shoot_cooldown
	else:
		shoot_timer -= delta
	
	if not in_shoot_zone:
		state = States.SHOOT

func shoot():
	var bullet = BULLET.instantiate()
	
	bullet.position = shoot_point.global_position
	bullet.rotation = shoot_point.global_rotation
	bullet.parent = $HurtBoxComponet
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

func _on_health_changed(_currenthp: float, _maxhp: float) -> void:
	damage_taken = true
