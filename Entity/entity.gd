extends CharacterBody2D
class_name Player

func _on_fire_ball_created_interval_timer(timer: Timer) -> void:
	$CanvasLayer/HBoxContainer/R.init(timer)
func _on_circular_chop_created_interval_timer(timer: Timer) -> void:
	$CanvasLayer/HBoxContainer/F.init(timer)

func _on_attack_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 16)
func _on_fire_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 16)
func _on_fire_ball_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 256)
func _on_circular_chop_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 512)

func _on_health_component_hited(dir: Vector2i) -> void:
	$MoveGravityByInput.set_velocity(-dir * 256)
