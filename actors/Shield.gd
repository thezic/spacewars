extends Node


export var shield_energy := 100.0
export var shield_reload := 20.0
export var shield_deplete := 200.0


onready var shield_node = $Node2D
onready var shield_sprite = $Node2D/ShieldSprite
onready var shield_energy_meter = $Node2D/ShieldEnergyMeter
onready var animation := $ShieldAnimation as AnimationPlayer
onready var shield_collider := $"../ShieldCollisionShape"
onready var state_machine := $ShieldStateMachine

onready var shield_state_machine := $ShieldStateMachine

var is_shielded := false setget _set_is_shielded

var remaining_shield_energy := shield_energy
var shield_depleted := false



func _readonly_setter(_value):
	pass


func _set_is_shielded(value: bool) -> void:
	is_shielded = value
	shield_collider.disabled = !is_shielded


func set_shielded(value: bool) -> void:
	if value == is_shielded:
		return
	animation.stop()
	is_shielded = value

	shield_sprite.visible = is_shielded
	shield_collider.disabled = !is_shielded


func try_activate_shield():
	shield_state_machine.send_event("activate_shield")


func deactivate_shield():
	shield_state_machine.send_event("deactivate_shield")


func deplete_shield():
	shield_state_machine.send_event("deplete_shield")


# Called when the node enters the scene tree for the first time.
func _ready():
	# shield_collider = get_node("../ShieldCollisionShape")
	#set_shielded(false)
	state_machine.context = {
		"shield": self,
		"shield_energy": shield_energy,
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	shield_node.position = get_parent().position
	shield_energy_meter.value = 100 * state_machine.context.shield_energy / shield_energy
	# shield_energy_meter.value = 100 * remaining_shield_energy / shield_energy

	#if is_shielded:
	#	remaining_shield_energy -= delta * shield_deplete
	#	shield_energy_meter.value = 100 * remaining_shield_energy / shield_energy
	#elif remaining_shield_energy < shield_energy:
	#	remaining_shield_energy += delta * shield_reload
	#	shield_energy_meter.value = 100 * remaining_shield_energy / shield_energy
	#else:
	#	shield_depleted = false
	#	shield_energy_meter.tint_progress = Color.aliceblue

	#if remaining_shield_energy >= shield_energy:
	#	shield_energy_meter.visible = false
	#else:
	#	shield_energy_meter.visible = true

	#if remaining_shield_energy <= 0:
	#	shield_depleted = true
	#	shield_energy_meter.tint_progress = Color.red
	#	set_shielded(false)

