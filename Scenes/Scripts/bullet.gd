extends Node2D

var speed := 3000.0
var damage := 10.0

var parent

func _ready() -> void:
	$Hitboxcomponet.damage = damage
	$Hitboxcomponet.parent = parent

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
