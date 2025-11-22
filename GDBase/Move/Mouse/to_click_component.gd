extends MoveComponentBase
class_name MoverToClickComponent
##该脚本用于赋予节点移动能力
##将该脚本挂载到任意Node类节点上，将mover赋值为需要移动能力的Node2D节点
@export var mover:Node2D
@export var move_time:float
var tween:Tween

func _process(delta: float) -> void:
	if !mover:
		return
	move_to_mouse()

func move_to_mouse():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if tween:
			tween.kill()
		tween = mover.create_tween()
		tween.tween_property(mover,"position",mover.get_global_mouse_position(),move_time)
