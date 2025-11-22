@tool
extends CellsProgressBar
class_name HealthCellsProgressBar

@export var health_component:HealthComponent:
	set(new_component):
		health_component = new_component
		if health_component:
			max_cells_num = health_component.max_health
			current_cells_num = health_component.current_health

func _ready() -> void:
	assert(health_component,"存在无归属的血量进度条组件")
	health_component.current_health_updated.connect(_change_cell_num)
