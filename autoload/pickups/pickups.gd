extends Node

var pickup_texture: Texture = preload("res://assets/sprites/pickups.png")
var Pickup = preload("res://objects/pickups/pickup.tscn")

var available_pickups2 = [
	PickupInfo.new(PickupInfo.PickupId.BLASTER_REPEAT, pickup_texture, 4, 1, 0),
	PickupInfo.new(PickupInfo.PickupId.BLASTER_SPREAD, pickup_texture, 4, 1, 1),
	PickupInfo.new(PickupInfo.PickupId.BOMB, pickup_texture, 4, 1, 2),
	# PickupInfo.new(PickupInfo.PickupId.COIN, pickup_texture, 4, 1, 3),
]

var available_pickups = {
	PickupInfo.PickupId.BLASTER_REPEAT: PickupInfo.new(PickupInfo.PickupId.BLASTER_REPEAT, pickup_texture, 4, 1, 0),
	PickupInfo.PickupId.BLASTER_SPREAD: PickupInfo.new(PickupInfo.PickupId.BLASTER_SPREAD, pickup_texture, 4, 1, 1),
	PickupInfo.PickupId.BOMB: PickupInfo.new(PickupInfo.PickupId.BOMB, pickup_texture, 4, 1, 2),
	PickupInfo.PickupId.COIN: PickupInfo.new(PickupInfo.PickupId.COIN, pickup_texture, 4, 1, 3),
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var aaa = [
	[PickupInfo.PickupId.BLASTER_SPREAD, 100],
	[PickupInfo.PickupId.BLASTER_REPEAT, 10],
]

func get_weighted_random(weights: Array) -> int:
	var sum := 0.0
	for weight in weights:
		sum += weight

	var r := rand_range(0, sum)
	for i in weights.size():
		var w = weights[i]
		r -= w

		if r < 0:
			return i
	return weights.size() - 1


func get_random_pickup(itemIds: Array, weights: Array):
	var i := get_weighted_random(weights)
	var id = itemIds[i]
	return available_pickups[id]


func create_pickup(pi: PickupInfo, pos: Vector2, dir: Vector2):
	var pickup = Pickup.instance()
	add_child(pickup)
	pickup.start(pos, dir, pi)
