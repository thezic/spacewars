class_name InputBuffer

extends Reference

enum ActionType {
	PRESSED,
	JUST_PRESSED,
	JUST_RELEASED,
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var prefix := ""
var actions := []
var buffer := {}


func _init(_prefix, _actions):
	prefix = _prefix
	actions = _actions

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update():
	var new_buffer = {}
	for action in actions:
		new_buffer[action] = {
			ActionType.PRESSED: Input.is_action_pressed(prefix + action),
			ActionType.JUST_PRESSED: Input.is_action_just_pressed(prefix + action),
			ActionType.JUST_RELEASED: Input.is_action_just_released(prefix + action),
		}

	buffer = new_buffer


func is_action_pressed(action: String) -> bool:
	if not buffer.has(action):
		return false
	return buffer[action][ActionType.PRESSED]


func is_action_just_pressed(action: String) -> bool:
	if not buffer.has(action):
		return false
	return buffer[action][ActionType.JUST_PRESSED]


func is_action_just_released(action: String) -> bool:
	if not buffer.has(action):
		return false
	return buffer[action][ActionType.JUST_RELEASED]