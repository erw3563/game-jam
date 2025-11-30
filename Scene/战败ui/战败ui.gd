extends CanvasLayer
class_name 战败ui
#######高级封装
static  func 获取战斗场景组(战斗场景_:Array[Node2D],玩家,下一关:Callable)->战斗场景:
	var 场景组:Array[战斗场景]=[]
	for i in 战斗场景_.size():
		场景组.append(获取战斗场景(战斗场景_[i],玩家,func ():pass))
	for i in 场景组.size():
		var a:战斗场景=场景组[i]
		a._场景_重来=场景组[0]
		a._场景_跳至=下一关
		if i<场景组.size()-1:
			a._下一关=func ():场景组[i+1].进入战斗()
		else :
			a._下一关=下一关
	return 场景组[0]



class 战斗场景:
	var _父节点:Node
	var _场景:Node
	var _玩家:Node
	var _下一关:Callable
	var _场景_使用中:Node
	var _场景_重来:战斗场景  #在多波敌人中使用
	var _场景_跳至:Callable
	var _选择中=false
	func 进入战斗():
		_玩家.禁用输入(false)
		if not _玩家.health_component.died.is_connected(_战败):
			_玩家.health_component.died.connect(_战败)
		var a=_场景.duplicate()
		_场景_使用中=a
		a.child_exiting_tree.connect(_战斗结束)
		for i in a.get_children():
			i.set("敌人",_玩家)
		_父节点.add_child(a)
	func _战斗结束(_a):
		if _场景_使用中.get_child_count()<=1: ###最后一个正在删除中
			_下一关_1()
	func _战败():
		if _选择中:
			print_debug("error")
			return
		_选择中=true
		_玩家.禁用输入(true)
		var a=await 战败ui.选择(_场景_使用中)
		match a:
			"重来":
				_场景_使用中.queue_free()
				_玩家.重置()
				if _场景_重来:
					_玩家.health_component.died.disconnect(_战败)
					_场景_重来.进入战斗()
				else :进入战斗()
			"继续":
				_玩家.health_component.current_health=_玩家.health_component.max_health
			"跳过":
				_场景_使用中.queue_free()
				_玩家.重置()
				if _场景_跳至:
					_场景_跳至.call()
				else :
					_下一关_1()
				return
		_玩家.禁用输入(false)
		_选择中=false
	func _下一关_1():
		_玩家.禁用输入(true)
		_玩家.health_component.died.disconnect(_战败)
		_下一关.call()
			
	
static  func 获取战斗场景(战斗场景_:Node2D,玩家,下一关:Callable)->战斗场景:
	var a=战斗场景.new()
	a._父节点=战斗场景_.get_parent()
	a._父节点.remove_child(战斗场景_)
	战斗场景_.visible=true
	a._场景=战斗场景_
	a._下一关=下一关
	a._玩家=玩家
	return a
	
	

###公开
#示例  可快速粘贴使用
	#var a=await 战败ui.选择(冻结区)
	#match a:
		#"重来":
			#for n in 冻结区.get_children():
				#if n==玩家:continue
				#n.queue_free()
			#玩家.重置()
			#
			#初始()
		#"继续":
			#玩家.health_component.current_health=玩家.health_component.max_health
		#"跳过":
			#下一关()
static  func 选择(暂停节点: Node)->String:  ##b 填一个可通往根节点
	await 暂停节点.get_tree().physics_frame
	var a=_c.instantiate()
	暂停节点.get_tree().root.add_child(a)
	#暂停节点.call_deferred("战败ui.暂停", true)
	暂停(暂停节点,true)
	var c=await a._选择
	a.queue_free()
	暂停(暂停节点,false)
	#暂停节点.call_deferred("战败ui.暂停", false)
	return c
static func 暂停(node: Node, pause: bool):
	# 停止/恢复 process & physics
	node.set_process(!pause)
	node.set_physics_process(!pause)

	## 停止/恢复动画播放器
	for ap in node.get_children():
		if ap is AnimationPlayer:
			ap.set_process(!pause)
			if pause: ap.stop() 
			else: ap.play()

	# 停止/恢复 Timer
	if node is Timer:
		node.set_process(!pause)
		if pause: node.stop()  
		else: node.start()

	# 递归子节点
	for child in node.get_children():
		暂停(child, pause)
###

	
signal _选择(String)
const _c=preload("res://Scene/战败ui/战败ui.tscn")
func _on_button_pressed() -> void:
	_选择.emit("重来")
func _on_button_2_pressed() -> void:
	_选择.emit("继续")
func _on_button_3_pressed() -> void:
	_选择.emit("跳过")
	

@export var button: Button
@export var button_2: Button
@export var button_3: Button

func _on_timer_timeout() -> void:
	button.disabled=false
	button_2.disabled=false
	button_3.disabled=false
