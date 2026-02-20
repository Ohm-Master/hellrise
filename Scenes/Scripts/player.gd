extends CharacterBody2D

class_name Player

const JUMP_SMOKE = preload("uid://ehwk1mq7udbc")

@onready var state_machine: Node = $State_machine
@onready var sprite: Node2D = $Sprite

const FRICTION := 1400.0

var gravity := 1500.0
var jump_force := -750.0
var move_speed := 950.0
var slide_speed := 1300.0
var air_speed := 850.0
var air_drag := 500.0
var can_double_jump := true
var is_sliding := false

var can_dash := true
var air_dashes := 3.0
var max_air_dashes := 3
var dash_cooldown := 0.18
var dash_cooldown_timer := 0.0
var dash_time := 0.13
var dash_timer := 0.0
var dash_speed := 3250
var dashing := false

var jump_buffer_timer := 0.0
var jump_buffer := 0.1

var coyote_time := 0.1
var coyote_timer := 0.0

enum DIR {
	RIGHT, #0
	LEFT, #1
	UP, #2
	DOWN, #3
	UP_LEFT, #4
	UP_RIGHT, #5
	DOWN_LEFT, #6
	DOWN_RIGHT, #7
}

var direction : DIR
var wall_jump_direction : DIR
var dash_direction : DIR


var fade_tween : Tween

func _ready() -> void:
	state_machine.init(self)
	#Fades out HP bar
	%Health_bar.modulate.a = 1
	fade_tween = create_tween()
	fade_tween.tween_property(%Health_bar, "modulate:a", 0.0, 1.0)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	apply_gravitiy(delta)
	move_and_slide()
	handle_animations()
	dash_direction = handle_dash_direction()

func _input(event: InputEvent) -> void:
	state_machine.process_input(event)
	if Input.is_action_pressed("Jump"):
		jump_buffer_timer = jump_buffer

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	jump_buffer_timer -= delta
	coyote_timer -= delta
	dash_cooldown_timer -= delta
	
	can_dash = dash_cooldown_timer <= 0
	air_dashes += delta * 0.5714
	air_dashes = clampf(air_dashes, 0, max_air_dashes)

func apply_gravitiy(delta : float):
	if not is_on_floor() and not state_machine.current_state is Wall_grab_state:
		velocity.y += gravity * delta
	else:
		can_double_jump = true

func handle_animations():
	if is_on_floor() and not is_on_wall_only():
		if velocity.x != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
	else:
		if state_machine.current_state is Double_jump_state:
			sprite.play("double_jump")
		else:
			sprite.play("fall")
		
	#flip the sprite and calculate dir
	if velocity.x > 0:
		sprite.scale.x = 1
		direction = DIR.RIGHT
	elif velocity.x < 0:
		direction = DIR.LEFT
		sprite.scale.x = -1
		
func add_smoke():
	var smoke = JUMP_SMOKE.instantiate()
	smoke.position = $Smoke_point.global_position
	get_tree().current_scene.add_child(smoke)
	smoke.play()
  
func has_buffered_jump() -> bool:
	return jump_buffer_timer > 0

func is_on_left_wall_only() -> bool:
	return $LeftWallTop.is_colliding() and $LeftWallMiddle.is_colliding() and $LeftWallBottom.is_colliding() and not is_on_floor()

func is_on_right_wall_only() -> bool:
	return $RightWallTop.is_colliding() and $RightWallMiddle.is_colliding() and $RightWallBottom.is_colliding() and not is_on_floor()
	
func is_touching_wall_only() -> bool:
	return (is_on_left_wall_only() or is_on_right_wall_only()) and not is_on_ceiling()
	
func can_air_dash() -> bool:
	return not floor(air_dashes) <= 0
	
func handle_dash_direction() -> DIR:
	if dashing:
		return dash_direction
		
	var horizontal := Input.get_axis("Left","Right")
	var vertical := Input.get_axis("Up", "Down")
	
	if is_on_floor():
		if vertical > 0:
			vertical = 0
	
	if is_touching_wall_only():
		horizontal *= -1
	
	if not horizontal == 0 and not vertical == 0:
		if vertical < 0:
			if horizontal >= 1:
				return DIR.UP_RIGHT
			else:
				return DIR.UP_LEFT
		else:
			if horizontal >= 1:
				return DIR.DOWN_RIGHT
			else:
				return DIR.DOWN_LEFT
	else:
		if vertical < 0:
			return DIR.UP
		elif vertical > 0:
			return DIR.DOWN
		elif horizontal > 0:
			return DIR.RIGHT
		elif horizontal < 0:
			return DIR.LEFT
	
	return direction
	
func dash_direction_to_Vector2() -> Vector2:
	var dir = Vector2.ZERO
	match dash_direction:
		DIR.UP: dir = Vector2.UP
		DIR.DOWN: dir = Vector2.DOWN
		DIR.LEFT: dir = Vector2.LEFT
		DIR.RIGHT: dir = Vector2.RIGHT
		DIR.UP_LEFT: dir = Vector2(-1, -1)
		DIR.UP_RIGHT: dir = Vector2(1, -1)
		DIR.DOWN_LEFT: dir = Vector2(-1, 1)
		DIR.DOWN_RIGHT: dir = Vector2(1, 1)
	return dir
	
func die():
	queue_free()

func disable_collision():
	$HurtBoxComponet.monitorable = false
	$HurtBoxComponet.monitoring = false
	$CollisionShape2D.disabled = true

func enable_collision():
	$HurtBoxComponet.monitorable = true
	$HurtBoxComponet.monitoring = true
	$CollisionShape2D.disabled = false
	
func enable_slide_collision():
	$SlideHurtBoxComponet.monitorable = true
	$HurtBoxComponet.monitoring = true
	$SlideCollisionShape.disabled = false

func disable_slide_collision():
	$SlideHurtBoxComponet.monitorable = false
	$HurtBoxComponet.monitoring = false	
	$SlideCollisionShape.disabled = true

func _on_health_changed(currenthp: float, maxhp: float) -> void:
	%Health_bar.value = currenthp
	%Health_bar.max_value = maxhp
	%Health_bar.modulate.a = 1
		
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()
	
	fade_tween = create_tween()
	fade_tween.tween_property(%Health_bar, "modulate:a", 0.0, 1.0)
