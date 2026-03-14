extends Node2D

var speed := 3000.0
var damage := 10.0

var parent
var the_owner : String

func _ready() -> void:
	$Hitboxcomponet.damage = damage
	$Hitboxcomponet.parent = parent
	$Hitboxcomponet.the_owner = the_owner

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
