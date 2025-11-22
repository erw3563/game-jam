extends Node
class_name MovePathComponent

signal moved(path:Array[Vector2])

@export var mover:Node2D

func move(path:Array[Vector2]):
	if !mover:
		push_error("路径移动组件无依赖的移动者。")
		return
	if path.size() == 0:
		print_debug("向路径移动组件输入的路径为空。")
	if path.size() == 1 and path.has(mover.position):
		print_debug("向路径移动组件输入的路径仅有移动者所在位置。")
	var tween:Tween = create_tween()
	for cell in path:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(mover,"position",cell,0.1)
		await tween.finished
	
	moved.emit(path)
