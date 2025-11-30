extends MoveComponentBase
class_name PlayerHorizontalMoveInCurveComponent

signal turned(dir:float)

@export var mover:CharacterBody2D
@export var max_speed:float = 128.0
@export var gravity:float = 12

@export_group("按键动作")
@export var left_action:String = "move_left"
@export var right_action:String = "move_right"
@export var up_action:String = "move_up"
@export var down_action:String = "move_down"

@export_group("跳跃")
@export var jump_power:float = 258
@export var max_jump_num:int = 1:
	set(value):
		max_jump_num = value
		jump_num = min(max_jump_num,jump_num)
@export var jump_num:int = 1:
	set(value):
		jump_num = clamp(value,0,max_jump_num)
@export_subgroup("狼跳")
@export var empty_jump_time:float = 0.5
var empty_jump_timer:Timer
@export_subgroup("空中移动速度偏移")
@export var jump_action_offset:float = 4 ##由跳跃键和下蹲键引起空中下落速度偏移
@export var air_velocity_x_multiplication:float = 0.8
@export_subgroup("跳跃提前输入容错")
@export var advance_input_jump_time:float = 0.2
var advance_input_jump_timer:Timer

@export_group("加速")
@export var time_faster:float = 1
@export var faster_curve:Curve
var faster_progress:float = 0:
	set(value):
		faster_progress = clamp(value,0,1)

@export_group("减速")
##当速度方向与加速度方向相反时，减速时间会少于设置时间
@export var time_slower:float = 1
@export var slower_curve:Curve
var slower_progress:float = 0:
	set(value):
		slower_progress = clamp(value,0,1)

var input_x:float
var input_y:float
var input_dir:Vector2
var mover_dir:float = 1

enum MoveState{
	Ground,
	Air}

var current_MoveState:MoveState

var external_velocity:Vector2 = Vector2.ZERO##外界设置的速度
var added_velocity:Vector2 = Vector2.ZERO##外界添加的速度

func set_velocity(velocity:Vector2):
	external_velocity = velocity

func set_added_velocity(velocity:Vector2):
	added_velocity = velocity

func get_velocity()->Vector2:
	return mover.velocity

func get_input_dir()->Vector2:
	return input_dir

func get_mover_pos()->Vector2:
	return mover.position

func _ready() -> void:
	empty_jump_timer = _create_timer(empty_jump_time)
	advance_input_jump_timer = _create_timer(advance_input_jump_time)

func _physics_process(delta: float) -> void:
	if !mover:
		return
	_check_input()
	_check_MoveState()
	_set_mover_velocity_x(delta)
	_set_mover_veloctiy_y()
	_check_external_setted_velocity()
	mover.move_and_slide()

func _check_input():
	input_x = Input.get_axis(left_action,right_action)
	input_y = Input.get_axis(up_action,down_action)
	input_dir = Input.get_vector(left_action,right_action,up_action,down_action)
	if !mover.is_on_floor() and Input.is_action_just_pressed(up_action):
		if advance_input_jump_timer.is_stopped():
			advance_input_jump_timer.start()
	if mover_dir != input_x and input_x != 0:
		mover_dir = input_x
		turned.emit(mover_dir)

func _check_MoveState():
	if mover.is_on_floor():
		if current_MoveState == MoveState.Ground:
			return
		current_MoveState = MoveState.Ground
		jump_num = max_jump_num
		empty_jump_timer.stop()
	else:
		if current_MoveState == MoveState.Air:
			return
		current_MoveState = MoveState.Air
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
	
	if !mover.is_on_floor() and input_x != 0:
		mover.velocity.x *= air_velocity_x_multiplication

func _deceleration(delta:float):
	faster_progress -= delta / time_faster
	slower_progress += delta / time_faster
	var curve_value = slower_curve.sample(slower_progress)
	var mover_velocity_x:float = mover.velocity.normalized().x
	
	if input_x == 0:
		mover.velocity.x = max_speed * curve_value * input_x
	else:
		mover.velocity.x = max_speed * curve_value * lerpf(mover_velocity_x,input_x,slower_progress)
	
	if !mover.is_on_floor() and input_x != 0:
		mover.velocity.x *= air_velocity_x_multiplication


func _set_mover_veloctiy_y():
	if mover.is_on_floor():
		mover.velocity.y = 0
	else:
		mover.velocity.y += gravity + input_y * jump_action_offset
	if jump_num > 0 and input_y == -1:
		mover.velocity.y = -jump_power 
		jump_num -= 1
	elif mover.is_on_floor() and !advance_input_jump_timer.is_stopped():
		mover.velocity.y = -jump_power 
		jump_num -= 1
		advance_input_jump_timer.stop()

##这是由外界干预设置的速度
func _check_external_setted_velocity():
	if external_velocity != Vector2.ZERO:
		mover.velocity = external_velocity
		external_velocity = Vector2.ZERO

func _check_added_velocity():
	if added_velocity != Vector2.ZERO:
		mover.velocity += added_velocity
		added_velocity = Vector2.ZERO

func _create_timer(time:float)->Timer:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	add_child(timer)
	return timer
