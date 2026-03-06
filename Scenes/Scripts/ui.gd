extends CanvasLayer

@onready var cursor_stamina_bar: TextureProgressBar = $Cursor_stamina_bar

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cursor_stamina_bar.position = event.position - cursor_stamina_bar.size / 2
