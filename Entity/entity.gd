extends CharacterBody2D


func _on_fire_ball_created_interval_timer(timer: Timer) -> void:
	$CanvasLayer/SkillBox.init(timer)
