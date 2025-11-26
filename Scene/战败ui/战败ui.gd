extends CanvasLayer
class_name 战败ui

###公开
#示例  可快速粘贴使用
#var a=await 战败ui.选择()
	#match a:
		#"重来":
			#pass
		#"继续":
			#pass
		#"跳过":
			#pass
static  func 选择(暂停节点: Node)->String:  ##b 填一个可通往根节点
	var a=_c.instantiate()
	暂停节点.get_tree().root.add_child(a)
	暂停(暂停节点,true)
	var c=await a._选择
	a.queue_free()
	暂停(暂停节点,false)
	return c
static func 暂停(node: Node, pause: bool):
	# 停止/恢复 process & physics
	node.set_process(!pause)
	node.set_physics_process(!pause)

	# 停止/恢复动画播放器
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
