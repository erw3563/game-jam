extends Node2D
class_name GrabThrowComponent

@export var throw_action:String = "throw"
@export var throw_velocity:float = 256
var throw_dir:Vector2
var grabed_character:CharacterBody2D
var is_throwing:bool

func _process(delta: float) -> void:
	if !grabed_character:
		return
	if !is_throwing:
		grabed_character.position = get_parent().position
	if Input.is_action_just_pressed(throw_action):
		is_throwing = true
		throw_dir = (get_global_mouse_position() - global_position).normalized()
		await get_tree().create_timer(0.5).timeout
		grabed_character = null
		throw_dir = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if !grabed_character:
		return
	grabed_character.velocity = throw_velocity * throw_dir
	grabed_character.move_and_slide()
