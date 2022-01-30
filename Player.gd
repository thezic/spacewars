extends Node

signal lives_updated(value)
signal player_gameover

# Number of lives
export(int) var lives := 3

# Position in global coordinates
# where player spawns
export(Vector2) var spawn_position := Vector2()

var Ship = preload("res://ship/Ship.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("lives_updated", lives)


func spawn_ship(reduce_lives = false):
	print("Spawn ship")
	if (reduce_lives):
		print("reduce lives")
		lives -= 1
		emit_signal("lives_updated", lives)

	var ship = Ship.instance()
	ship.start(spawn_position)

	var err = ship.connect("ship_destroyed", self, "_on_ship_destroyed")
	if err:
		print("Error connecting ship signal" + str(err))

	get_parent().add_child(ship)


func _on_ship_destroyed():
	print("Lives remaining: " + str(lives))
	if 0 == lives:
		emit_signal("player_gameover")
		print("GAME OVER")
		return

	$SpawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
