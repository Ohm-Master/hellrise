extends Node2D


#func _process(delta):
#	rotation_degrees += 50 * delta 

func play(anim: String):
	match anim:
		"run":
			%AnimationPlayer.play("Run")
		"idle":
			%AnimationPlayer.play("Idle")
		"fall":
			%AnimationPlayer.play("Fall")
		"double_jump":
			%AnimationPlayer.play("Double_Jump")
			await get_tree().create_timer(0.4).timeout
			%AnimationPlayer.play("Fall")
