extends CharacterBody2D
class_name Player

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
