extends Control

var timer:Timer

func init(timer_:Timer):
	timer = timer_
	timer.timeout.connect(_on_timer_out)

func _process(delta: float) -> void:
	if !timer:
		return
	if !timer.is_stopped():
		$Label.text = str(timer.time_left)

func _on_timer_out():
	$Label.text = ""
	print("我知道计时器结束了")
