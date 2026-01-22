extends CharacterBody2D

class_name Player

const JUMP_SMOKE = preload("uid://ehwk1mq7udbc")

@onready var state_machine: Node = $State_machine
@onready var sprite: Node2D = $Sprite

var gravity := 1500.0
var jump_force := -750.0
var move_speed := 850.0
var slide_speed := 1200.0
var air_speed := 850.0
var air_drag := 500.0
var can_double_jump := true
var is_sliding := false

enum DIR {
	LEFT,
	RIGHT,
}
var direction : DIR

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

func die():
	queue_free()

func _on_health_changed(currenthp: float, maxhp: float) -> void:
	%Health_bar.value = currenthp
	%Health_bar.max_value = maxhp
	%Health_bar.modulate.a = 1
		
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()
	
	fade_tween = create_tween()
	fade_tween.tween_property(%Health_bar, "modulate:a", 0.0, 1.0)
