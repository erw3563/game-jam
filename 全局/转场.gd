extends AnimationPlayer
#######高级封装

func 切换章节_并丢弃(场景自己:Node,路径:String)->void: 
	var a=转场
	a.加载完毕.connect(func ():场景自己.queue_free())
	a.切换章节(路径)
##场景自己  当前场景  ,  函数 返回触发
func 切换章节_之后返回(场景自己:Node,路径:String,函数:Callable)->void: 
	var a=转场
	var parent=场景自己.get_parent()
	a.加载完毕.connect(func ():parent.remove_child(场景自己))
	var c=await  a.切换章节(路径)
	c.tree_exited.connect(func ():
		parent.add_child(场景自己)
		函数.call()
		)

#######基础
	
signal 入场  ##入场开始
signal 加载完毕  ### 入场结束  下一个场景,加载完成
signal 退场  ##退场完毕
func 切换章节(路径:String)->Node:  ##返回新场景
	play("入场")
	入场.emit()
	await animation_finished
	var b:PackedScene=load(路径)
	var c=b.instantiate()
	c.ready.connect(func ():
		加载完毕.emit()
		play("退场")
		await animation_finished
		退场.emit()
		)
	get_tree().root.add_child(c)
	return c
	
