extends Node
class_name HealthBleedComponent
##该脚本是HealthRegenComponent的换皮

signal bleeded

@export var health_component:HealthComponent

@export_group("流血效果参数")
##每隔几秒触发一次再生效果
@export var bleed_interval_time:float = 1:
	set(value):
		bleed_interval_time = max(0,value)
##再生效果触发次数
@export var bleed_num:int = 0
##再生恢复血量数值
@export var bleed_health_amount:int = 1:
	set(value):
		bleed_health_amount = max(0,value)
var health_bleed_timer:Timer

@export_group("计时机制")
##当处于回合制中，下方的time为状态持续回合数，需要外部信号控制time减少
##当处于即时制中，下方的time就是状态持续时间，通过内部计时器控制time减少
@export var is_turn_based:bool

func enable_health_bleed(bleed_num_:int,
bleed_health_amount_:int,
bleed_interval_time_:float = bleed_interval_time):
	
	bleed_health_amount = bleed_health_amount_
	
	if bleed_num != -1:
		bleed_num += bleed_num_
	else:
		bleed_num = bleed_num_
	
	bleed_interval_time = bleed_interval_time_
	
	if is_turn_based:
		return
	
	if !health_bleed_timer:
		health_bleed_timer = _create_timer_with_callable(_bleed)
	if !health_bleed_timer.is_stopped():
		await health_bleed_timer.timeout
	health_bleed_timer.wait_time = bleed_interval_time
	health_bleed_timer.start()


func _bleed():
	if bleed_num == -1 or bleed_num > 0:
		health_component.damage(bleed_health_amount)
		bleeded.emit()
	
	if bleed_num != -1:
		bleed_num = max(0,bleed_num - 1)
	
	if is_turn_based :
		return
	if bleed_num == -1 or bleed_num > 0:
		health_bleed_timer.start()

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
	
	if bleed_num != -1:
		bleed_num = max(0,bleed_num - 1)
		_bleed()
	
	if bleed_num == 0:
		bleed_num = false
