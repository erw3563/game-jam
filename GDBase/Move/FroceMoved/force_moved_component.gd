extends Area2D
class_name ForceMovedComponent

signal force_moved(path:Array[Vector2])
signal to_request_move(dirs:Array[Vector2i])

@export var mover:Node2D
@export var self_running:bool
@export var cell_size:float

func force_move(dirs:Array[Vector2i]):
	if !self_running:
		to_request_move.emit(dirs)
		return
	
	var tween:Tween
	var path:Array[Vector2]
	for dir in dirs:
		tween = create_tween()
		var target_pos = mover.position + dir * cell_size
		tween.tween_property(mover,"position",target_pos,0.1)
		await tween.finished
		if tween:
			tween.kill()
		path.append(mover.position)
	force_moved.emit(path)
