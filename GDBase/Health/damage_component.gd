extends Area2D
class_name DamageComponent

signal attacked(area:Area2D)

@export var whitelist:Array[Node]
@export_group("伤害参数")
##伤害间隔
@export var attack_interval:float = 5
##伤害量
@export var damage_amount:int = 1
##伤害次数
@export var damage_num:int = 1
@export_group("附加效果")
@export var is_bleed_damage:bool = false
@export var bleed_damage_amout:int = 1
@export var bleed_num:int = 1
var damage_enemies:Array
var attack_timer:Timer

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func set_node_enter_whitelist(node:Node):
	whitelist.append(node)

func reset():
	whitelist.clear()
	damage_enemies.clear()

func attack_enemies():
	if damage_enemies:
		await get_tree().create_timer(attack_interval).timeout
		for enemy in damage_enemies:
			var dir:Vector2 = sign(global_position - enemy.global_position)
			for i in damage_num:
				enemy.damage_with_dir(damage_amount,dir)
			attacked.emit()

func _create_attack_timer():
	if !attack_timer:
		attack_timer = Timer.new()
		attack_timer.wait_time = attack_interval
		attack_timer.timeout.connect(attack_enemies)
		add_child(attack_timer)
		attack_timer.start()

func _on_area_entered(area: Area2D) -> void:
	if !(area is HealthComponent):
		return
	if whitelist.has(area.get_parent()):
		return
	var dir:Vector2 = sign(global_position - area.global_position)
	for i in damage_num:
		area.damage_with_dir(damage_amount,dir)
	attacked.emit(area)
	_create_attack_timer()
	if is_bleed_damage:
		for child in area.get_children():
			if child is HealthBleedComponent:
				child.enable_health_bleed(bleed_num,bleed_damage_amout)
	damage_enemies.append(area)
