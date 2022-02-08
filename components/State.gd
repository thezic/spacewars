class_name State, "State.png"
extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var machine = $".."


#func _state_process(_context, _delta):
#	pass
#
#
#func _state_physics_process(_context, _delta):
#	pass
#
#
#func _enter_state(_context):
#	pass
#
#
#func _exit_state(_context):
#	pass

func handle_event(event: String, context: Dictionary, data: Dictionary):
	_handle_event(event, context, data)


func _handle_event(event: String, context: Dictionary, data: Dictionary):
	var handler_name = "_handle_event_" + event

	if has_method(handler_name):
		call(handler_name, context, data)


func transition(next_state, data = {}):
	machine.call_deferred("transition", next_state, data)
