extends AnimatedSprite2D
class_name 职业
@export var 切换按键:String
@export var 普攻_图标:Texture2D
###切换职业_调用
func 切换(a:职业):
	_切出()
	a._切入()
func _切入():
	pass
func _切出():
	pass
##


func 普攻():
	pass
