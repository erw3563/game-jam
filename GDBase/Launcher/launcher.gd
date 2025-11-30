extends Node2D
class_name Launcher

@onready var spawner: Spawner = Spawner.new()

@export var shooter:Node
@export var gun:Node2D ##子弹将会在gun的位置生成，最好将gun和发射器设置为同一节点
@export var bullet_scene:PackedScene

@export_group("射击参数")
@export var fire_interval:float = 0.1
var is_fire_interval:bool
var fire_interval_timer:Timer
@export var fire_bullet_num:int = 1
@export var max_scatter_angle:float

@export_group("弹匣参数")
@export var magaazine_capacity:int = 30
@export var remaining_bullets:int = -1:
	set(value):
		remaining_bullets = clampi(value,-1,magaazine_capacity)
@export var reload_time:float

@export_group("子弹参数")
@export var bullet_velocity:float
@export var bullet_exit_time:float = -1

@export_group("对象池设置")
@export var max_bullet_num:int = 20

func _ready() -> void:
	add_child(spawner)
	spawner.init(bullet_scene,max_bullet_num)

func _start_interval_timer():
	if !fire_interval_timer:
		fire_interval_timer = Timer.new()
		fire_interval_timer.one_shot = true
		fire_interval_timer.timeout.connect(func():is_fire_interval = false)
		add_child(fire_interval_timer)
	fire_interval_timer.start(fire_interval)

func fires(fire_dir:Vector2,bullet_mods:Array[Node] = []):
	for i in fire_bullet_num:
		fire(fire_dir,bullet_mods)
		await get_tree().create_timer(0.02).timeout

func fire(fire_dir:Vector2,bullet_mods:Array[Node] = []):
	if remaining_bullets != 0:
		var bullet:Bullet = spawner.request_instance()
		bullet.global_position = gun.global_position
		for mod in bullet_mods:
			bullet.install_mod(mod)
		spawner.add_child(bullet)
		var scatter_angel = randf_range(-max_scatter_angle,+max_scatter_angle)
		var dir = fire_dir.rotated(scatter_angel)
		bullet.init(shooter,bullet_velocity * dir,bullet_exit_time)
	
	if remaining_bullets > 0:
		remaining_bullets = max(0,remaining_bullets - 1)

func reload():
	if remaining_bullets != -1:
		await get_tree().create_timer(reload_time).timeout
		remaining_bullets = magaazine_capacity
