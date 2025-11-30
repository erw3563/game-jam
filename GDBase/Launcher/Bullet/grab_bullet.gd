extends Bullet
class_name GrabBullet

func _on_damage_component_attacked(area: Area2D) -> void:
	var node2d:CharacterBody2D = area.get_parent()
	node2d.position = shooter.position
	shooter.grab_component.grabed_character = node2d
