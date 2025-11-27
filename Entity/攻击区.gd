extends Area2D

@export var 攻击力:int=1
##请填正数 无需考虑方向,需要父节点的[图片_方向] 受[质量影响,默认1]

@export var 击飞强度:Vector2  =Vector2(2,1)
func _on_area_entered(area: Area2D) -> void:
	if area is HealthComponent:
		var a=get_parent().get("图片_方向")
		if a:
			area.damage_with_dir(攻击力,击飞强度*Vector2(-a,1))
		else :
			area.damage(攻击力)


func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
