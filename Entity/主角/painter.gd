extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("skill_f") or Input.is_action_pressed("skill_r"):
		show()
		queue_redraw()
	else:
		hide()

func _draw() -> void:
	draw_line(Vector2.ZERO,get_local_mouse_position(),Color.WHITE)
