@tool
#extends CellsProgressBar
extends Node2D
class_name HealthCellsProgressBar

@export var health_component:HealthComponent:
	set(new_component):
		health_component = new_component
		#if health_component:
			#max_cells_num = health_component.max_health
			#current_cells_num = health_component.current_health

func _ready() -> void:
	assert(health_component,"存在无归属的血量进度条组件")
	#health_component.current_health_updated.connect(_change_cell_num)
	health_component.current_health_updated.connect(func (_a):queue_redraw())

const 长度=3
####血条绘制
func _draw() -> void:
	if health_component.current_health<=0:return
	var a=Vector2(0,0)
	画线(Vector2(0,0),Vector2.RIGHT)
	while -a.y<health_component.current_health*长度:
		画框(a)
		a.y-=长度
	
func 画线(f:Vector2,t:Vector2)->Vector2:
	draw_line(f,f+t*长度,Color.AZURE,1)
	return f+t*长度
func 画框(a:Vector2):
	a=画线(a,Vector2.UP)
	a=画线(a,Vector2.RIGHT)
	画线(a,Vector2.DOWN)
