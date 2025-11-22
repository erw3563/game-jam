extends Node
class_name HealthRegenComponent

signal regened

@export var health_component:HealthComponent

@export_group("流血效果参数")
##每隔几秒触发一次再生效果
@export var regen_interval_time:float = 1:
	set(value):
		regen_interval_time = max(0,value)
##再生效果触发次数
@export var regen_num:int = 0
##再生恢复血量数值
@export var regen_health_amount:int = 1:
	set(value):
		regen_health_amount = max(0,value)
var health_regen_timer:Timer

@export_group("计时机制")
##当处于回合制中，下方的time为状态持续回合数，需要外部信号控制time减少
##当处于即时制中，下方的time就是状态持续时间，通过内部计时器控制time减少
@export var is_turn_based:bool

func enable_health_regen(regen_num_:int,
regen_health_amount_:int,
regen_interval_time_:float = regen_interval_time):
	
	regen_health_amount = regen_health_amount_
	
	if regen_num != -1:
		regen_num += regen_num_
	else:
		regen_num = regen_num_
	
	regen_interval_time = regen_interval_time_
	
	if is_turn_based:
		return
	
	if !health_regen_timer:
		health_regen_timer = _create_timer_with_callable(_regen)
	if !health_regen_timer.is_stopped():
		await health_regen_timer.timeout
	health_regen_timer.wait_time = regen_interval_time
	health_regen_timer.start()


func _regen():
	if regen_num == -1 or regen_num > 0:
		health_component.heal(regen_health_amount)
		regened.emit()
	
	if regen_num != -1:
		regen_num = max(0,regen_num - 1)
	
	if is_turn_based :
		return
	if regen_num == -1 or regen_num > 0:
		health_regen_timer.start()

##Timer计时器
func _create_timer_with_callable(on_time_out_callable:Callable)->Timer:
	var new_timer = Timer.new()
	new_timer.one_shot = true
	new_timer.timeout.connect(on_time_out_callable)
	add_child(new_timer)
	return new_timer

##连接回合结束信号
func on_trun_down():
	if !is_turn_based:
		return
	
	if regen_num != -1:
		regen_num = max(0,regen_num - 1)
		_regen()
	
	if regen_num == 0:
		regen_num = false
