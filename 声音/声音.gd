extends Node
var 正在播放:AudioStreamPlayer

@onready var 剧情1: AudioStreamPlayer = $剧情1
@onready var 剧情2: AudioStreamPlayer = $剧情2
@onready var 剧情3: AudioStreamPlayer = $剧情3
@onready var 剧情4: AudioStreamPlayer = $剧情4
@onready var 战斗1: AudioStreamPlayer = $战斗1
@onready var 战斗2: AudioStreamPlayer = $战斗2
@onready var 战斗3: AudioStreamPlayer = $战斗3

func _ready() -> void:
	更换音乐(剧情4)
func 更换音乐(a:AudioStreamPlayer):
	if a==正在播放:return
	if 正在播放:正在播放.stop()
	a.play()
	正在播放=a
	
