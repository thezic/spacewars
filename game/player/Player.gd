extends Node

signal lives_updated(value)
signal player_gameover

# Number of lives
export(int) var lives := 3

# Position in global coordinates
# where player spawns
export(Vector2) var spawn_position := Vector2()
export(Array, PackedScene) var available_weapons := []

var current_weapon_index := 0
var current_ship = null

var player_stats = {
	Items.ItemID.BLASTER: { 'spread': 0, 'repeat': 0.9 },
	Items.ItemID.BOMB_LAUNCHER: { 'spread': 0, 'repeat': 1 },
}

# var weapon_stats

var Ship = preload("res://actors/Ship.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	lives = 3
	emit_signal("lives_updated", lives)

func get_current_weapon():
	return available_weapons[current_weapon_index]

func get_next_weapon():
	current_weapon_index = (current_weapon_index + 1) % available_weapons.size()
	return available_weapons[current_weapon_index]

func spawn_ship(reduce_lives = false):
	print("Spawn ship")
	if (reduce_lives):
		print("reduce lives")
		lives -= 1
		emit_signal("lives_updated", lives)

	var ship = Ship.instance()

	var err = ship.connect("ship_destroyed", self, "_on_ship_destroyed")
	if err:
		print("Error connecting ship signal" + str(err))

	add_child(ship)
	ship.connect("pickup", self, "_player_recieved_pickup")
	ship.mount_weapon(available_weapons[current_weapon_index], get_stats())
	ship.start(spawn_position, reduce_lives)
	current_ship = ship


func _on_ship_destroyed():
	print("Lives remaining: " + str(lives))
	if 0 == lives:
		emit_signal("player_gameover")
		print("GAME OVER")
		return

	$SpawnTimer.start()


func _player_recieved_pickup(pickup: PickupInfo):
	match pickup.id:
		PickupInfo.PickupId.BLASTER_REPEAT:
			print("Upgrade blaster repeate")
			var current = player_stats[Items.ItemID.BLASTER].repeat
			player_stats[Items.ItemID.BLASTER].repeat = max(current * 0.98, 0.1)
			_remount_weapon()
		PickupInfo.PickupId.BLASTER_SPREAD:
			print("Upgrade blaster spread")
			var current = player_stats[Items.ItemID.BLASTER].spread
			player_stats[Items.ItemID.BLASTER].spread = min(current + 1, 5)
			_remount_weapon()
	
	print(player_stats)
	
func get_stats():
	var id = Items.get_id(get_current_weapon())
	return player_stats[id]
	
func _remount_weapon():
	current_ship.mount_weapon(get_current_weapon(), get_stats())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
