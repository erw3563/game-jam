extends Control

@export var txt_path:String = "res://hello_world.txt"
var file:FileAccess = FileAccess.open(txt_path,FileAccess.READ)
var words:String
var word_num:int
var saying_word_num:int

@export var words_box:RichTextLabel
@export var name_box:RichTextLabel

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		show_words()

func show_words():
	if saying_word_num == word_num:
		var line:String = file.get_line()
		name_box.text = line.get_slice(":",0)
		words = line.get_slice(":",1)
		word_num = words.get_slice_count("/")
		saying_word_num = 0
	var new_text = words.get_slice("/",saying_word_num)
	for i in new_text.length():
		words_box.text = new_text.erase(i,new_text.length() - i)
		await get_tree().create_timer(0.05).timeout
	words_box.text = new_text
	saying_word_num += 1
