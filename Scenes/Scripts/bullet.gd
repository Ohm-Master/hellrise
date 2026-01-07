extends Node2D

var speed := 3000.0
var damage := 10.0

func _ready() -> void:
	$Hitboxcomponet.damage = damage

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
