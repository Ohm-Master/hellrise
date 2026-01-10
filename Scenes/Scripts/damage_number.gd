extends Node2D


var bob_time := 0.0
var bob_speed := 7.0
var bob_height := 60.0

func _ready() -> void:
	$Label.rotation_degrees = randi_range(-45, 45)

func _process(delta: float) -> void:
	bob_time += delta * bob_speed
	$Label.position.y = sin(bob_time) * bob_height
	
	var tween := create_tween()
	tween.tween_property($Label, "modulate:a", 0.0, 0.7)
	pass

func setup(amount):
	$Label.text = "-" + str(amount)
