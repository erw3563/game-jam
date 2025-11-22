extends Area2D
class_name HealthComponent
##我们规定血量组件中的-1代表无敌时间无限

signal health_delta_applied(amount:int)
signal current_health_updated(current_health_:int)
signal died
signal to_die

var is_dead:bool = false

@export_group("血量参数")
@export var max_health:int = 1:
	set(value):
		max_health = value
		current_health = current_health
@export var current_health:int:
	set(value):
		current_health = clamp(value,-1,max_health)
		current_health_updated.emit(current_health)
		if current_health == 0:
			died.emit()

@export_group("机制")
##当处于回合制中，下方的time为状态持续回合数，需要外部信号控制time减少
##当处于即时制中，下方的time就是状态持续时间，通过内部计时器控制time减少
@export var is_turn_based:bool
@export var is_stop_before_death:bool

@export_group("特殊效果")
@export var is_invulnerable:bool = false
@export var invulnerable_time:float = 0
var invulnerable_timer:Timer

@export var is_heal_blocked:bool = false
@export var heal_blocked_time:float = 0
var heal_blocked_timer:Timer

@export var is_health_blocked:bool = false
@export var health_blocked_time:float = 0
var health_blocked_timer:Timer

@export var is_reverse_damage:bool = false
@export var reverse_damage_time:float = 0
var reverse_damage_timer:Timer

@export var is_reverse_heal:bool = false
@export var reverse_heal_time:float = 0
var reverse_heal_timer:Timer

#region 血量相关
func damage(amount:int):
	if is_invulnerable:
		return
	if current_health == -1:
		return
	
	amount = absi(amount)
	if is_health_blocked:
		amount = 0
	if is_reverse_damage:
		amount = -amount
	
	if current_health - amount <= 0 and current_health != -1:
		to_die.emit()
		if is_stop_before_death:
			return
	
	change_current_health(-amount)
	
	health_delta_applied.emit(-amount)

func heal(amount:int):
	if is_heal_blocked:
		return
	if current_health == -1:
		return
	
	amount = absi(amount)
	if is_health_blocked:
		amount = 0
	if is_reverse_heal:
		amount = -amount
	
	if current_health + amount <= 0 and current_health != -1:
		to_die.emit()
		if is_stop_before_death:
			return
	
	change_current_health(+amount)
	
	health_delta_applied.emit(amount)

##我们公开这一方法，让外界可以在不触发血量差值信号的情况下修改单位的血量
func change_current_health(amount:int):
	##最小值设为零，防止一般情况下血量等于-1进入无限血量状态
	current_health = max(0,current_health + amount)
#endregion

#region 状态相关
func enable_invulnerable(enable:bool,time:float = -1):
	is_invulnerable = enable
	invulnerable_time = time
	
	if !is_turn_based and invulnerable_time != -1:
		if !invulnerable_timer:
			var callable:Callable = enable_invulnerable.bind(false,0)
			invulnerable_timer = _create_timer_with_callable(callable)
		_update_timer_time(invulnerable_timer,invulnerable_time)

func enable_heal_blocked(enable:bool,time:float = -1):
	is_heal_blocked = enable
	heal_blocked_time = time
	
	if !is_turn_based and heal_blocked_time != -1:
		if !heal_blocked_timer:
			var callable:Callable = enable_heal_blocked.bind(false,0)
			heal_blocked_timer = _create_timer_with_callable(callable)
		_update_timer_time(heal_blocked_timer,heal_blocked_time)

func enable_health_blocked(enable:bool,time:float = -1):
	is_health_blocked = enable
	health_blocked_time = time
	
	if !is_turn_based and health_blocked_time != -1:
		if !health_blocked_timer:
			var callable:Callable = enable_health_blocked.bind(false,0)
			health_blocked_timer = _create_timer_with_callable(callable)
		_update_timer_time(health_blocked_timer,health_blocked_time)

func enable_reverse_damage(enable:bool,time:float = -1):
	is_reverse_damage = enable
	reverse_damage_time = time
	
	if !is_turn_based and reverse_damage_time != -1:
		if reverse_damage_timer:
			var callable:Callable = enable_reverse_damage.bind(false,0)
			reverse_damage_timer = _create_timer_with_callable(callable)
		_update_timer_time(reverse_damage_timer,reverse_damage_time)

func enable_reverse_heal(enable:bool,time:float = -1):
	is_reverse_heal = enable
	reverse_heal_time = time
	
	if !is_turn_based and reverse_heal_time != -1:
		if !reverse_heal_timer:
			var callable:Callable = enable_reverse_heal.bind(false,0)
			reverse_heal_timer = _create_timer_with_callable(callable)
		_update_timer_time(reverse_heal_timer,reverse_heal_time)
#endregion

#region 计时器相关
##Timer计时器
func _create_timer_with_callable(on_time_out_callable:Callable)->Timer:
	var new_timer = Timer.new()
	new_timer.one_shot = true
	new_timer.timeout.connect(on_time_out_callable)
	add_child(new_timer)
	return new_timer

func _update_timer_time(timer:Timer,time:float):
	if !timer.is_stopped():
		time += timer.time_left
		timer.stop()
	timer.start(time)


##连接回合结束信号
func on_trun_down():
	if !is_turn_based:
		return
	
	if invulnerable_time != -1:
		invulnerable_time = max(0,invulnerable_time - 1)
	if heal_blocked_time != -1:
		heal_blocked_time = max(0,heal_blocked_time - 1)
	if health_blocked_time != -1:
		health_blocked_time = max(0,health_blocked_time - 1)
	if reverse_damage_time != -1:
		reverse_damage_time = max(0,reverse_damage_time - 1)
	if reverse_heal_time != -1:
		reverse_heal_time = max(0,reverse_heal_time - 1)
	
	if invulnerable_time == 0:
		invulnerable_time = false
	if heal_blocked_time == 0:
		heal_blocked_time = false
	if health_blocked_time == 0:
		health_blocked_time = false
	if reverse_damage_time == 0:
		reverse_damage_time = false
	if reverse_heal_time == 0:
		reverse_heal_time = false
#endregion
