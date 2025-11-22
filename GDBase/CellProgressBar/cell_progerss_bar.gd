@tool
extends Node2D
class_name CellsProgressBar
##这是一个简单的格子进度条，为什么不使用Control？
##使用Control制作格子进度条的方便之处在于BoxContainer可以轻松排列血量格子
##但是在测试过程中BoxContainer有似乎有无法取消最小间距，在低比特画面下间距变得尤其明显，所以不使用Control

const cell_scene_path:String = "res://GDBase/CellProgressBar/progress_cell.tscn"
const cell_size_x:int = 2
const cell_size_y:int = 3

@export var max_cells_num:int:
	set(new_num):
		max_cells_num = new_num
		current_cells_num = current_cells_num
@export var current_cells_num:int:
	set(new_num):
		new_num = clamp(new_num,0,max_cells_num)
		if current_cells_num == new_num:
			return
		elif current_cells_num > new_num:
			_recycle_cells(current_cells_num - new_num)
			current_cells_num = new_num
		else :
			_spawner_cells(new_num - current_cells_num)
		current_cells_num = new_num

@export var vertical:bool:
	set(value):
		vertical = value
		_reset_cell_rotation_degrees()

var cells:Array[Sprite2D]

var cell_spawner:Spawner

func _reset_cell_rotation_degrees():
	if vertical:
		rotation_degrees = 90
	else:
		rotation_degrees = 0

func _change_cell_num(new_num:int):
	current_cells_num = new_num

func _spawner_cells(num:int):
	_create_cell_spawner()
	for i in num:
		var cell:Sprite2D = cell_spawner.request_instance()
		cells.append(cell)
		cell.position.y = -(cells.size() - 1) * cell_size_y
		add_child(cell)

func _recycle_cells(num:int):
	_create_cell_spawner()
	for i in num:
		var cell = cells.pop_back()
		cell_spawner.recycle_instance(cell)

func _create_cell_spawner():
	if !cell_spawner:
		cell_spawner = Spawner.new()
		var cell:PackedScene = load(cell_scene_path)
		cell_spawner.init(cell)
