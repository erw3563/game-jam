extends Node
class_name DashComponent

signal dashed(dash_dir:Vector2)

@export var player_move_component:PlayerHorizontalMoveInCurveComponent
@export var dash_action:String = "dash"
@export var dash_time:float = 0.2
@export var dash_speed:float = 256
@export var dash_interval_time:float = 1
var dash_timer:Timer
var dash_interval_timer:Timer
var external_dash_dir:Vector2

func set_dash_dir(dash_dir:Vector2):
	if dash_interval_timer.is_stopped():
		dash_timer.start()
		dash_interval_timer.start()
		external_dash_dir = dash_dir
		dashed.emit(external_dash_dir)

func _ready() -> void:
	_create_dash_timer()
	_create_dash_interval_timer()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	_check_dash()
	_dash()

func _check_dash():
	if Input.is_action_just_pressed(dash_action) and dash_interval_timer.is_stopped():
		dash_timer.start()
		dash_interval_timer.start()
		external_dash_dir = Vector2.ZERO
		var input_dir:Vector2 = player_move_component.get_input_dir()
		dashed.emit(input_dir)

func _dash():
	if dash_timer.is_stopped():
		return
	if external_dash_dir != Vector2.ZERO:
		player_move_component.set_velocity(external_dash_dir * dash_speed)
	else:
		var input_dir:Vector2 = player_move_component.get_input_dir()
		player_move_component.set_velocity(input_dir * dash_speed)

func _create_dash_timer():
	dash_timer = Timer.new()
	dash_timer.one_shot = true
	dash_timer.wait_time = dash_time
	add_child(dash_timer)

func _create_dash_interval_timer():
	dash_interval_timer = Timer.new()
	dash_interval_timer.one_shot = true
	dash_interval_timer.wait_time = dash_interval_time
	add_child(dash_interval_timer)
