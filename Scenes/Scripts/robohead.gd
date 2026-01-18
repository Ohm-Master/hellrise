extends CharacterBody2D

#TODO:
#Add anims
#Add death anim

const BULLET = preload("uid://d1kqj34jeqaf")
const EXPLOSION_EFFECT = preload("uid://b24hi0mxc88hi")

@onready var raycast: RayCast2D = $RayCast
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var shoot_point: Marker2D = $Shootpoint
@export var player : CharacterBody2D

enum States {
	IDLE,
	CHASE,
	SHOOT,
	BACKUP, 
	DIE
}

var state = States.IDLE

var in_chase_zone := false
var in_shoot_zone := false
var in_back_up_zone := false
var damage_taken := false

var move_speed := 600
var damage := 20.0
var shoot_cooldown := 0.5
var shoot_timer := 1.0

var bob_time := 0.0
var bob_speed := 5.0
var bob_height := 10.0

func _ready():
	shoot_timer = 0

func _physics_process(delta: float) -> void:
	handle_states(delta)
	move_and_slide()
	calculate_zones()

	

func handle_states(delta : float):
	match state:
		States.IDLE:
			idle_state(delta)
		States.CHASE:
			chase_state(delta)
		States.SHOOT:
			shoot_state(delta)
		States.BACKUP:
			back_up_state(delta)
		States.DIE:
			death_state()
			
func idle_state(delta : float):
	sprite.play("Idle")
	velocity = velocity.move_toward(Vector2.ZERO, move_speed / 2)
	
	bob_time += delta * bob_speed
	sprite.position.x = sin(bob_time) * bob_height

	rotation = lerp_angle(rotation, PI / 2, 2 * delta)
	if in_chase_zone or damage_taken:
		state = States.CHASE
	
func chase_state(delta : float):
	if player:
		var target_angle = global_position.angle_to_point(player.global_position)
		rotation = lerp_angle(rotation, target_angle, 8.0 * delta)
		var direction := global_position.direction_to(player.global_position)
		velocity = direction * move_speed
	
	sprite.play("Attack")
	
	if not in_chase_zone and not damage_taken:
		state = States.IDLE
	if in_shoot_zone:
		state = States.SHOOT
	
func shoot_state(delta : float):
	sprite.play("Attack")
	if player:
		var target_angle = global_position.angle_to_point(player.global_position)
		rotation = lerp_angle(rotation, target_angle, 8.0 * delta)
	velocity = velocity.move_toward(Vector2.ZERO, move_speed / 2)
	
	if shoot_timer <= 0:
		shoot()
		shoot_timer = shoot_cooldown
	else:
		shoot_timer -= delta
	
	if in_back_up_zone:
		state = States.BACKUP
	if not in_shoot_zone:
		state = States.CHASE

func back_up_state(delta : float):
	if player:
		var target_angle = global_position.angle_to_point(player.global_position)
		rotation = lerp_angle(rotation, target_angle, 8.0 * delta)
		var direction := global_position.direction_to(player.global_position)
		velocity = -direction * move_speed
	
	if not in_back_up_zone:
		state = States.SHOOT

func death_state():
	$HurtBoxComponet.monitoring = false
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	explosion()
	queue_free()

func shoot():
	var bullet = BULLET.instantiate()
	
	bullet.position = shoot_point.global_position
	bullet.rotation = shoot_point.global_rotation
	bullet.parent = $HurtBoxComponet
	bullet.damage = damage
	
	get_tree().current_scene.add_child(bullet)
	
	if not in_shoot_zone:
		state = States.CHASE

func explosion():
	var explosion_effect = EXPLOSION_EFFECT.instantiate()
	
	explosion_effect.position = global_position
	
	get_tree().current_scene.add_child(explosion_effect)

func die():
	state = States.DIE

func calculate_zones():
	if player:
		raycast.target_position = to_local(player.global_position)
		raycast.force_raycast_update()
		var hit = raycast.get_collider()
		if hit and not hit.is_in_group("Player"):
			in_shoot_zone = false
			in_chase_zone = false
		else:
			for i in $Chase_zone.get_overlapping_bodies():
				if i.is_in_group("Player"):
					in_chase_zone = true
					break
			for i in $Shoot_zone.get_overlapping_bodies():
				if i.is_in_group("Player"):
					in_shoot_zone = true
					break
			

	
func _on_chase_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var hit = raycast.get_collider()
		if hit and hit.is_in_group("Player"):
			in_chase_zone = true
		else:
			in_chase_zone = false
	if body.is_in_group("Player"):
		in_chase_zone = false

func _on_shoot_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var hit = raycast.get_collider()
		if hit and hit.is_in_group("Player"):
			in_shoot_zone = true
		else:
			in_shoot_zone = false
func _on_shoot_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_shoot_zone = false

func _on_backup_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var hit = raycast.get_collider()
		if hit and hit.is_in_group("Player"):
			in_back_up_zone = true
		else:
			in_back_up_zone = false
func _on_backup_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_back_up_zone = false
	
func _on_health_changed(_currenthp: float, _maxhp: float) -> void:
	damage_taken = true
