extends CharacterBody2D


func _on_fire_ball_created_interval_timer(timer: Timer) -> void:
	$CanvasLayer/SkillBox.init(timer)


func _on_attack_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 16)
func _on_fire_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 16)
func _on_fire_ball_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 256)
func _on_circular_chop_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 16)
