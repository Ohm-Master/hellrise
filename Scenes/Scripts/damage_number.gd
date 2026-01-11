extends Node2D


var bob_time := 0.0
var bob_speed := 5.5
var bob_height := 60.0

var sway_time := 0.0
var sway_speed := 4.0
var sway_length := 50.0

var sway_direction := randf() < 0.5

var timer : float = 0.4

func _ready() -> void:
	$Label.rotation_degrees = randi_range(-35, 35)
	randomize()

func _process(delta: float) -> void:
	timer -= delta
	bob_time += delta * bob_speed
	$Label.position.y = -sin(bob_time) * bob_height
	
	sway_time += delta * sway_speed
	if sway_direction == true:
		$Label.position.x = -sin(sway_time) * sway_length
	else:
		$Label.position.x = sin(sway_time) * sway_length

	if timer <= 0:
		var tween := create_tween()
		tween.tween_property($Label, "modulate:a", 0.0, 0.1)
		tween.finished.connect(queue_free)
	
	print(sin(bob_time) * bob_height)

func final_hit():
	$Label.label_settings.font_size = 50

func setup(amount):
	$Label.text = "-" + str(amount)
