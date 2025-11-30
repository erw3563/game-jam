extends CharacterBody2D
class_name Player_2


@onready var health_component: HealthComponent = $HealthComponent
@onready var camera_2d: Camera2D = $Camera2D
@onready var player_move_component: PlayerHorizontalMoveInCurveComponent = $MoveGravityByInput

##用于 战败 中的 重来
func 重置():
	health_component.current_health=health_component.max_health
	position=_初始位置
	
func 禁用输入(a:bool):   ##用于剧情 以及 战斗
	player_move_component.set_physics_process(!a)
	禁用攻击=a
	
func 冻结(a:bool):###用于跳转场景,但保留当前
	禁用输入(a)
	camera_2d.enabled=!a

var 初始缩放:Vector2
func 镜头至屏幕(a:Control):##用于剧情
	禁用输入(true)
	camera_2d.enabled=true
	var 左上=a.global_position
	var 右下=a.scale*a.size+左上
	var 中间=0.5*(左上+右下)
	var 大小:Vector2=a.scale*a.size
	var 倍率=Vector2(get_viewport().get_visible_rect().size)/大小
	var aaa=max(倍率.x,倍率.y)
	var b =get_tree().create_tween()
	b.set_parallel(true)  
	b.tween_property(camera_2d,"global_position",中间,1) 
	b.tween_property(camera_2d,"zoom",Vector2(aaa,aaa),1)
	await b.finished
	
func 镜头至屏幕_复原():
	var b =get_tree().create_tween()
	b.set_parallel(true) 
	b.tween_property(camera_2d,"position",Vector2.ZERO,1)  
	b.tween_property(camera_2d,"zoom",初始缩放,1)
	await b.finished
	禁用输入(false)
	
####

func _ready() -> void:
	_初始位置=position
	切换职业(切[0])
	鼠标右键.冷却时间=4
	鼠标右键.冷却结束.connect(func ():可_闪现=true)
	初始缩放=camera_2d.zoom
	
func 限制相机移动(a:Control):
	var b=a.global_position
	var c=a.scale*a.size+b
	camera_2d.limit_left=b.x
	camera_2d.limit_top=b.y
	camera_2d.limit_right=c.x
	camera_2d.limit_bottom=c.y
###
var _初始位置:Vector2

func _on_fire_ball_created_interval_timer(timer: Timer) -> void:
	$CanvasLayer/HBoxContainer/R.init(timer)
func _on_circular_chop_created_interval_timer(timer: Timer) -> void:
	$CanvasLayer/HBoxContainer/F.init(timer)

func _on_attack_fired(dir: Vector2) -> void:
	player_move_component.set_velocity(-dir * 16)
func _on_fire_fired(dir: Vector2) -> void:
	player_move_component.set_velocity(-dir * 16)
func _on_fire_ball_fired(dir: Vector2) -> void:
	player_move_component.set_velocity(-dir * 256)
func _on_circular_chop_fired(dir: Vector2) -> void:
	player_move_component.set_velocity(-dir * 512)

func _on_health_component_hited(dir: Vector2i) -> void:
	player_move_component.set_velocity(-dir * 256)
	
############
var player_dir=1
@onready var 切:Array[职业]=[$剑2,$弓,$盾]
@onready var 当前职业:职业
var 锁定:bool=false:
	set(a):
		锁定=a
		player_move_component.set_physics_process(!a)
		if a:velocity=Vector2.ZERO

func 切换职业(a:职业):
	当前职业=a
	鼠标左键.技能_图标=a.普攻_图标

var 禁用攻击=false
@onready var 鼠标左键 = $CanvasLayer/右下/鼠标左键
func _process(_delta: float) -> void:
	if 锁定 or 禁用攻击:return
	for i in 切:
		if Input.is_action_just_pressed(i.切换按键):
			切换职业(i)
			break
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
	velocity=Vector2(500 * player_dir,0)
	move_and_slide()


@onready var 鼠标右键 = $CanvasLayer/右下/鼠标右键
var 可_闪现:bool=true
func 闪现():
	可_闪现=false
	模式=闪现_
	health_component.monitorable=false
	await  get_tree().create_timer(0.25).timeout
	health_component.monitorable=true
	模式=空
	鼠标右键.冷却()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _on_health_component_health_delta_applied(_amount: int) -> void:
	animation_player.play("受击")


func _on_move_gravity_by_input_turned(dir_: float) -> void:
	scale.x = -scale.x
	player_dir = dir_
