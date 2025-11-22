extends MoveComponentBase
class_name DraggedByMouseComponent
##该脚本赋予父节点被鼠标拖拽的能力
##由于无法确定父节点的大小，所以获取鼠标点击启动拖拽的任务需要交给其他脚本

@export var mover:Node2D
var is_dragged:bool = true

func _process(delta: float) -> void:
	if is_dragged and mover:
		follow_mouse_move()

func follow_mouse_move():
	mover.position = mover.get_global_mouse_position()

func dragged_by_mouse():
	is_dragged = true
func placed_by_mouse():
	is_dragged = false
