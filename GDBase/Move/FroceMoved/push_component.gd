extends Area2D
class_name PushComponent

##受迫物体将会按照此数组给出的方向进行移动。
@export var dirs:Array[Vector2i]

func init(dirs_:Array[Vector2i]):
	dirs = dirs_

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is ForceMovedComponent:
		area.force_move(dirs)
