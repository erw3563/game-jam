extends Launcher
class_name PlayerLauncher

@export_group("射击按键")
@export var fire_action:String = "fire"
@export var reload_action:String = "reload"

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_pressed(reload_action):
		reload()
	
	if Input.is_action_pressed(fire_action) and !is_fire_interval:
		var dir = get_local_mouse_position() - gun.position
		fires(dir.normalized())
		is_fire_interval = true
		_start_interval_timer()
