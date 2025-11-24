extends  RichTextLabel
class_name  文字渐变
func _ready() -> void:
	bbcode_enabled=true
	if text.is_empty():
		set_process(false)
	else :
		吐字(text)
####供外部 使用
@export var 吐字间隔:float=0.4
@export_range(1,10) var 渐变字数:int=3
signal 吐字完毕
func 吐字(a:String):
	_在渐变.assign(a.split(""))
	渐变=0
	_显示完毕=""
	_吐字冷却=0
	set_process(true)
####

var _显示完毕:String
var _在渐变:Array[String]
var _吐字冷却:float=0

var 渐变周期:float=吐字间隔*渐变字数
var 渐变:float
func _process(delta: float) -> void:
	_吐字冷却-=delta
	渐变+=delta
	if 渐变>=渐变周期:
		渐变-=吐字间隔
		if _在渐变.is_empty():
			set_process(false)
			吐字完毕.emit()
			return
		_显示完毕+=_在渐变.pop_front()
	text=_显示完毕
	for i in _在渐变.size():
		var 透明度=(渐变-(i-1)*吐字间隔)/渐变周期
		text+="[color="+Color(1.0, 1.0, 1.0,透明度).to_html() +"]"+_在渐变[i]+"[/color]"

		
