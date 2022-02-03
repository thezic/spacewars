extends Node2D

signal world_clear

var check_for_asteroids := false

var Asteroid = preload("res://objects/asteroid/Asteroid.tscn")

onready var spawn_point: PathFollow2D = $AsteroidSpawnPath/AsteroidSpawnPosition
onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready():
	player.spawn_position = get_viewport_rect().size / 2
	reset()

func reset():
	check_for_asteroids = false
	get_tree().call_group('asteroids', 'queue_free')
	player.reset()
	player.spawn_ship()


func start(nr_asteroids: int):
	for _i in range(nr_asteroids):
		var asteroid = Asteroid.instance()

		spawn_point.offset = randi()
		var pos = spawn_point.position
		var dir = spawn_point.transform.y
		asteroid.start(-1, pos, dir.rotated(rand_range(-PI/3, PI/3)))

		asteroid.connect("asteroid_destroyed", self, "_asteroid_destroyed")
		add_child(asteroid)

	check_for_asteroids = true

func _asteroid_destroyed(size: int) -> void:
	print("destroyed asteroid")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if check_for_asteroids:
		var nr_of_asteroids := get_tree().get_nodes_in_group("asteroids").size()
		if nr_of_asteroids == 0:
			check_for_asteroids = false
			emit_signal("world_clear")
