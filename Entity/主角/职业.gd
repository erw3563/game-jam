extends AnimatedSprite2D
class_name 职业
@export var animationPlayer:AnimationPlayer

func 切入():
	_攻击段数_当前=0

func 普攻():
	animationPlayer.play(_普攻[_攻击段数_当前])
	_攻击段数_当前=(_攻击段数_当前+1)%_普攻.size()
	await animationPlayer.animation_finished
var _攻击段数_当前:int=0
@export var _普攻:Array[String]=[]
