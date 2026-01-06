extends CharacterBody2D

class_name Player

const JUMP_SMOKE = preload("uid://ehwk1mq7udbc")

@onready var state_machine: Node = $State_machine

var gravity := 1500.0
var jump_force := -750.0
var move_speed := 700.0

@onready var sprite: Node2D = $Sprite

var can_double_jump := true

func _ready() -> void:
	state_machine.init(self)
	#Fades out HP bar
	var tween := create_tween() 
	%Health_bar.modulate.a = 1
	
	tween.tween_property(%Health_bar, "modulate:a", 0.0, 1.0)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	apply_gravitiy(delta)
	move_and_slide()
	handle_animations()
	
func _input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func apply_gravitiy(delta : float):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_double_jump = true

func handle_animations():
	if is_on_floor():
		if velocity.x != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
	else:
		if state_machine.current_state is Double_jump_state:
			sprite.play("double_jump")
		else:
			sprite.play("fall")
		
	#flip the sprite
	if velocity.x > 0:
		sprite.scale.x = 1
	elif velocity.x < 0:
		sprite.scale.x = -1
		
func add_smoke():
	var smoke = JUMP_SMOKE.instantiate()
	smoke.position = $Smoke_point.global_position
	get_tree().current_scene.add_child(smoke)
	smoke.play()

func _on_health_changed(currenthp: float, maxhp: float) -> void:
	
	var tween := create_tween()
	
	%Health_bar.value = currenthp
	%Health_bar.max_value = maxhp
	%Health_bar.modulate.a = 1
		
	tween.tween_property(%Health_bar, "modulate:a", 0.0, 1.0)
