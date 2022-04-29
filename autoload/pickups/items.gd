extends Node

enum ItemID {
    BLASTER = 1,
    BOMB_LAUNCHER = 2,
}

var Item = {
    ItemID.BLASTER: preload("res://actors/items/blaster.tscn"),
    ItemID.BOMB_LAUNCHER: preload("res://actors/items/bomb_launcher.tscn"),
}

var reverse_map = {}

func _ready():
	for id in Item.keys():
		var item = Item[id]	
		reverse_map[item] = id


func get_id(scene):
	return reverse_map[scene]