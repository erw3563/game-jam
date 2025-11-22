extends MoveComponentBase
class_name MoveGravityByInputComponent

@export var mover:CharacterBody2D
@export var max_speed:float = 128.0
@export var gravity:float = 12
@export var jump_power:float = 12
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

var input_dir:float

func _physics_process(delta: float) -> void:
	input_dir = Input.get_axis("move_left","move_right")

func accelerate(delta:float):
	add_faster_progress(delta)
	faster_progress += delta / time_faster
	var curve_value = faster_curve.sample(faster_progress)
	mover.velocity.x = max_speed * curve_value * input_dir

func deceleration(delta:float):
	add_slower_progress(delta)
	var curve_value = slower_curve.sample(slower_progress)
	var mover_velocity_x:float = mover.velocity.normalized().x
	if input_dir == 0:
		mover.velocity.x = max_speed * curve_value * mover_velocity_x
	else:
		mover.velocity.x = max_speed * curve_value * mover_velocity_x

func add_faster_progress(delta:float):
	faster_progress += delta / time_faster
	slower_progress -= delta / time_slower

func add_slower_progress(delta:float):
	faster_progress -= delta / time_faster
	slower_progress += delta / time_slower
