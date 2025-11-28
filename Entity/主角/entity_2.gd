extends CharacterBody2D
class_name Player_2


@onready var health_component: HealthComponent = $HealthComponent
@onready var move_gravity_by_input: MoveGravityByInputComponent = $MoveGravityByInput
@onready var camera_2d: Camera2D = $Camera2D

####

##用于 战败 中的 重来
func 重置():
	health_component.current_health=health_component.max_health
	position=_初始位置
	#await get_tree().physics_frame  无法处理 受击 的 击飞
	#velocity=Vector2.ZERO
	
func 禁用输入(a:bool):   ##用于剧情
	move_gravity_by_input.set_physics_process(!a)
	
func 冻结(a:bool):###用于跳转场景,但保留当前
	禁用输入(a)
	camera_2d.enabled=!a
####

func _ready() -> void:
	_初始位置=position
	鼠标右键.冷却时间=6
	鼠标右键.冷却结束.connect(func ():可_闪现=true)

###
var _初始位置:Vector2

func _on_fire_ball_created_interval_timer(timer: Timer) -> void:
	$CanvasLayer/HBoxContainer/R.init(timer)
func _on_circular_chop_created_interval_timer(timer: Timer) -> void:
	$CanvasLayer/HBoxContainer/F.init(timer)

func _on_attack_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 16)
func _on_fire_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 16)
func _on_fire_ball_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 256)
func _on_circular_chop_fired(dir: Vector2) -> void:
	$MoveGravityByInput.set_velocity(-dir * 512)

func _on_health_component_hited(dir: Vector2i) -> void:
	$MoveGravityByInput.set_velocity(-dir * 256)
	
	
	
############
var 图片_方向=1
@onready var 剑: 职业 = $剑2
@onready var 弓: 职业 = $弓
@onready var 盾: 职业 = $盾
@onready var 当前职业:职业=剑
var 锁定:bool=false:
	set(a):
		锁定=a
		move_gravity_by_input.set_physics_process(!a)
		
func _process(_delta: float) -> void:
	if 锁定:return
	if Input.is_action_just_pressed("attack"):
		锁定=true
		await  当前职业.普攻()
		锁定=false
	elif 可_闪现==true and Input.is_action_just_pressed("闪现"):
		锁定=true
		await  闪现()
		锁定=false

var 模式:Callable=空
func 空(_delta: float) -> void:pass
func _physics_process(delta: float) -> void:
	模式.call(delta)
func 闪现_(_delta: float) -> void:
	velocity=Vector2(750*图片_方向,0)
	move_and_slide()


@onready var 鼠标右键 = $CanvasLayer/右下/鼠标右键
var 可_闪现:bool=true
func 闪现():
	可_闪现=false
	模式=闪现_
	await  get_tree().create_timer(0.25).timeout
	模式=空
	鼠标右键.冷却()
	#可_闪现=false
	print(可_闪现)


func _on_move_gravity_by_input_转向() -> void:
	scale.x=-scale.x
	图片_方向=-图片_方向

@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _on_health_component_health_delta_applied(_amount: int) -> void:
	animation_player.play("受击")
