extends Node

#todo:制作场景转换效果

@export var next_scene:PackedScene

##用于单出口场景，只要在该节点进行赋值就能够使用
func enter_next_scene():
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)

func enter_scene(scene:PackedScene):
	get_tree().change_scene_to_packed(scene)
