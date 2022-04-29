extends Node


onready var launcher = $Launcher

func initialize(parent: Node, muzzle: Node2D, ob: Node2D):
	launcher.instances_parent = parent
	launcher.owner_body = ob
	launcher.muzzle_position = muzzle

func set_stats(stats):
	launcher.set_stats(stats)
	print(stats)

func fire_just_pressed():
	launcher.fire_just_pressed()


func fire_just_released():
	launcher.fire_just_released()

