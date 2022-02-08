class_name StateMachine, "StateMachine.png"
extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var context := {}

var current_state setget _readonly_setter

var states := {}

func _readonly_setter(_value):
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		states[child.name] = child

	call_deferred("transition", get_children()[0].name)
	#current_state = get_children()[0]


func _process(delta):
	if current_state and current_state.has_method("_state_process"):
		current_state._state_process(context, delta)


func _physics_process(delta):
	if current_state && current_state.has_method("_state_physics_process"):
		current_state._state_physics_process(context, delta)


func transition(next_state_name, data := {}):
	var next = states[next_state_name]

	assert(next, "Unable to find state " + next_state_name)

	if current_state and current_state.has_method("_exit_state"):
		current_state._exit_state(context, data)

	current_state = next

	if current_state.has_method("_enter_state"):
		current_state._enter_state(context, data)


func send_event(event: String, data := {}):
	current_state.handle_event(event, context, data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
