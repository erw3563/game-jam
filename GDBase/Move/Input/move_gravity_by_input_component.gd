extends MoveComponentBase
class_name MoveGravityByInputComponent

@export var mover:CharacterBody2D
@export var max_speed:float = 128.0
@export var gravity:float = 12
@export var jump_power:float = 12
@export var max_jump_num:int = 1:
	set(value):
		max_jump_num = value
		jump_num = min(max_jump_num,jump_num)
@export var jump_num:int = 1:
	set(value):
		jump_num = clamp(value,0,max_jump_num)
@export var empty_jump_time:float = 0
@export var dash_time:float = 1
@export var dash_speed:float = 256
##请注意，若需要加速时间严格等于下方时间，需要您的加速曲线在结尾处才达到最高点
##减速时间同理，在结尾处达到最低点
@export var time_faster:float = 1 ##加速时间
##这里注明，当速度方向与加速度方向相反时，减速时间会更少
@export var time_slower:float = 1 ##减速时间
@export var faster_curve:Curve ##加速曲线
@export var slower_curve:Curve ##减速曲线
var faster_progress:float = 0: ##加速进度
	set(value):
		faster_progress = clamp(value,0,1)
var slower_progress:float = 0: ##减速进度
	set(value):
		slower_progress = clamp(value,0,1)

var empty_jump_timer:Timer
var dash_timer:Timer

var input_x:float
var input_y:float

enum State{
	Ground,
	Air
}

var current_state:State

var attack_move_velocity:Vector2 = Vector2.ZERO

func _ready() -> void:
	empty_jump_timer = _create_timer(empty_jump_time)
	dash_timer = _create_timer(dash_time)

func _physics_process(delta: float) -> void:
	if !mover:
		return
	_check_input()
	_check_state()
	_set_mover_velocity_x(delta)
	_set_mover_veloctiy_y()
	_seted_move_by_other()
	_check_dash()
	mover.move_and_slide()

func _check_input():
	input_x = Input.get_axis("move_left","move_right")
	input_y = Input.is_action_pressed("move_up")
	if Input.is_action_just_pressed("dash"):
		dash_timer.start()

func _check_state():
	if mover.is_on_floor():
		if current_state == State.Ground:
			return
		current_state = State.Ground
		jump_num = max_jump_num
		empty_jump_timer.stop()
	else:
		if current_state == State.Air:
			return
		current_state = State.Air
		if empty_jump_timer.is_stopped() and mover.velocity.y > 0:
			empty_jump_timer.start()
			await empty_jump_timer.timeout
			jump_num -= 1

func _set_mover_velocity_x(delta:float):
	if input_x == 0 and mover.velocity.x != 0:
		_deceleration(delta)
	elif input_x == - mover.velocity.x:
		_deceleration(delta)
	elif input_x != 0:
		_accelerate(delta)

func _accelerate(delta:float):
	faster_progress += delta / time_faster
	slower_progress -= delta / time_faster
	var curve_value = faster_curve.sample(faster_progress)
	mover.velocity.x = max_speed * curve_value * input_x

func _deceleration(delta:float):
	faster_progress -= delta / time_faster
	slower_progress += delta / time_faster
	var curve_value = slower_curve.sample(slower_progress)
	var mover_velocity_x:float = mover.velocity.normalized().x
	if input_x == 0:
		var a=mover.velocity.x
		mover.velocity.x=a-a*delta*10 if abs(a)>1 else 0.0 ## 平滑停下
	else:
		mover.velocity.x = max_speed * curve_value * lerpf(mover_velocity_x,input_x,slower_progress)

func _set_mover_veloctiy_y():
	if mover.is_on_floor():
		mover.velocity.y=0
	else:
		mover.velocity.y += gravity
	
	if jump_num > 0 and Input.is_action_just_pressed("move_up"):
		mover.velocity.y = - input_y * jump_power
		jump_num -= 1

func _create_timer(time:float)->Timer:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	add_child(timer)
	return timer

func _check_dash():
	if !dash_timer.is_stopped():
		mover.velocity.x = dash_speed * signf(mover.velocity.x)

func _seted_move_by_other():
	if attack_move_velocity != Vector2.ZERO:
		mover.velocity.x = attack_move_velocity.x
		attack_move_velocity = Vector2.ZERO

func set_velocity(velocity:Vector2):
	attack_move_velocity = velocity
