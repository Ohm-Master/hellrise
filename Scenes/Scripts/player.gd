extends CharacterBody2D

class_name Player

const JUMP_SMOKE = preload("uid://ehwk1mq7udbc")

@onready var state_machine: Node = $State_machine

const SPEED = 700.0
const JUMP_VELOCITY = -750.0
const GRAVITY := 1500.0

@onready var sprite: Node2D = $Sprite

var can_double_jump := true

var double_jumped := false

func _ready() -> void:
	state_machine.init(self)
	#Fades out HP bar
	var tween := create_tween() 
	%Health_bar.modulate.a = 1
	
	tween.tween_property(%Health_bar, "modulate:a", 0.0, 1.0)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
#
##func idle_state():
#	velocity.x = move_toward(velocity.x, 0, SPEED / 9)
#	
#	var direction := Input.get_axis("Left", "Right")
#	if direction:
#		state = State.RUN
#	if Input.is_action_just_pressed("Jump"):
#		state = State.JUMP
#	elif not is_on_floor():
#		state = State.FALL
##
##func run_state():
#	
#	var direction := Input.get_axis("Left", "Right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		state = State.IDLE
#		
#	if Input.is_action_just_pressed("Jump"):
#		state = State.JUMP
#	elif not is_on_floor():
#		state = State.FALL
##	
##func jump_state():
#	velocity.y = JUMP_VELOCITY
#	state = State.FALL
##
##func fall_state():
#	var direction := Input.get_axis("Left", "Right")
#	velocity.x = direction * SPEED
#	
#	if Input.is_action_just_pressed("Jump") and not is_on_floor() and can_double_jump:
#		state = State.DOUBLE_JUMP
#	
#	if is_on_floor():
#		if direction:
#			state = State.RUN
#		else:
#			state = State.IDLE
##
##func double_jump_state():
#	var smoke = JUMP_SMOKE.instantiate()
#	smoke.position = $Smoke_point.global_position
#	get_tree().current_scene.add_child(smoke)
#	smoke.play()
#	can_double_jump = false
#	double_jumped = true
#	velocity.y = JUMP_VELOCITY
#	state = State.FALL

func apply_gravitiy(delta : float):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		can_double_jump = true
		double_jumped = false

func handle_animations():
	if is_on_floor():
		if velocity.x != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
	else:
		if double_jumped:
			sprite.play("double_jump")
		else:
			sprite.play("fall")
		
	#flip the sprite
	if velocity.x > 0:
		sprite.scale.x = 1
	elif velocity.x < 0:
		sprite.scale.x = -1
		

func _on_health_changed(currenthp: float, maxhp: float) -> void:
	
	var tween := create_tween()
	
	%Health_bar.value = currenthp
	%Health_bar.max_value = maxhp
	%Health_bar.modulate.a = 1
		
	tween.tween_property(%Health_bar, "modulate:a", 0.0, 1.0)
