extends CanvasLayer

class_name TextBox

###这是公开的
#敏感符号
#  : 用于分割 角色名 与 话 (每行必须有一个,首个) （统一用中文）
# [] 用于加工 文字
# 空行 允许
func 开始(a:String):
	visible=true
	剧本.assign(a.split("\n"))
	
	剧本.assign(剧本.filter(func(line): return line.strip_edges().length() > 0) \
		.map(func(line): return line.strip_edges()))
	进度=0
	下一段()
@export var 话间_间隔:float=1 ##仅用于 自动播放 还没做
signal 结束

#有别的地方使用
static func 切割对话(a:String)->Array[String]:
	var c:Array[String]=[]
	var b=a.find("：")
	c.append(a.substr(0,b))
	c.append(a.substr(b+1,a.length()-b-1))
	return c
######

@onready var 名字: RichTextLabel = $"Control/VBoxContainer/名字/Control/PanelContainer/MarginContainer/Label"
@onready var text: 文字渐变 = $"Control/VBoxContainer/文本框/MarginContainer/文字渐变"

var 剧本:Array[String]
var 进度:int

func 下一段():
	if 进度<剧本.size():
		var a=切割对话(剧本[进度])
		assert(a.size()==2)
		名字.text=a[0]
		text.吐字(a[1])
	else :
		visible=false
		结束.emit()
	进度+=1

func _on_texture_button_pressed() -> void:
	if text.显示完毕_或立即显示():下一段()
	
		

@onready var texture_button_2: TextureButton = $TextureButton2
@onready var juben: Control = $剧本

func _on_texture_button_2_pressed() -> void:
	texture_button_2.visible=false
	juben.初始(剧本.slice(0,进度))
	juben.visible=true


func _on_剧本_关闭() -> void:
	texture_button_2.visible=true
