extends Bullet
class_name TeleportBullet

func _on_damage_component_attacked(area: Area2D) -> void:
	var node2d:CharacterBody2D = area.get_parent()
	shooter.position = node2d.position
