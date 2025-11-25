extends  RichTextLabel
class_name  文字渐变
func _ready() -> void:
	bbcode_enabled=true
	if text.is_empty():
		set_process(false)
	else :
		吐字(text)
	渐变周期=吐字间隔*渐变字数
####供外部 使用
@export var 吐字间隔:float=0.4
@export_range(1,10) var 渐变字数:int=3
signal 吐字完毕
func 吐字(a:String):
	#字符切割(a)
	_在渐变=字符切割(a)
	渐变=0
	_显示完毕=""
	_吐字冷却=0
	set_process(true)
func 显示完毕_或立即显示()->bool:  ##ture 为 显示完毕 false 会执行 显示剩余所有
	if _在渐变.size()<=0:return true
	text=_显示完毕+"".join(_在渐变)
	_在渐变=[]
	set_process(false)
	return false
	
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
		if 透明度>0:
			text+="[color="+Color(1.0, 1.0, 1.0,透明度).to_html() +"]"+_在渐变[i]+"[/color]"
		else :
			var t="".join(_在渐变.slice(i))
			text+="[color="+Color(1.0, 1.0, 1.0,透明度).to_html() +"]"+t+"[/color]"
			break

		


static func 字符切割(t: String) -> Array[String]:
	var a:Array[String]=[]
	var regex = RegEx.new()
	regex.compile(r"(\[/.*?\])|(\[.*?\])|(.)")  ## 标签结束 开始 剩余
	var result = regex.search_all(t)
	var 标签=false
	var 标签_名字:String
	var 标签_内容:String
	for match in result:
		if not 标签:
			if match.get_string(2):
				标签=true
				标签_内容=match.get_string(0)
				标签_名字=标签_内容.substr(1,标签_内容.length()-2)
				print(标签_名字)
				pass
			elif match.get_string(1):
				assert(false)
			elif match.get_string(3):
				a.append(match.get_string(0))
		else :
			if match.get_string(1):
				var b=match.get_string(0)
				b=b.substr(2,b.length()-3)
				标签_内容+=match.get_string(0)
				if 标签_名字==b:
					标签=false
					a.append(标签_内容)
			else :
				标签_内容+=match.get_string(0)
	
	return a
	
	
	
	
	
	
	
	
