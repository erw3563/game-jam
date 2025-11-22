extends MoveComponentBase
class_name MoveInParameterByInputComponent
@export var mover:CharacterBody2D
@export var max_speed :float = 128.0 ##最大移动速度
@export var acceleration :float = 12.0 ##加速度
@export var friction := 6.0 ##摩擦力（仅在无输入时用于减速）
var input_dir:Vector2

func _physics_process(delta: float) -> void:
	if !mover:
		return
	move_in_parameter(delta)

func move_in_parameter(delta: float):
	input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	mover.velocity = mover.velocity.lerp(input_dir * max_speed, acceleration * delta)
	if input_dir == Vector2.ZERO :
		mover.velocity = mover.velocity.move_toward(Vector2.ZERO, friction * delta)
	mover.move_and_slide()
