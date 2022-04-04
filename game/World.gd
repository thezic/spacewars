extends Node2D

signal world_clear

var check_for_asteroids := false
var initial_asteroids: int

var Asteroid = preload("res://objects/asteroid/Asteroid.tscn")
var FloatingScore = preload("res://ui/FloatingScore.tscn")

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

func _count_asteroids() -> int:
	return get_tree().get_nodes_in_group("asteroids").size()


func start(nr_asteroids: int) -> void:
	initial_asteroids = nr_asteroids
	for _i in range(nr_asteroids):
		var asteroid = Asteroid.instance()

		spawn_point.offset = randi()
		var pos = spawn_point.position
		var dir = spawn_point.transform.y
		asteroid.start(-1, pos, dir.rotated(rand_range(-PI/3, PI/3)))
		asteroid.on_destroyed_clb = funcref(self, "_asteroid_destroyed")

		add_child(asteroid)

	check_for_asteroids = true

func _asteroid_destroyed(size: int, pos: Vector2) -> void:
	var score = Score.calculate_score_for_asteroid(size, _count_asteroids(), initial_asteroids)
	Score.create_floating_score(score, pos)


func _process(_delta):
	if check_for_asteroids:
		var nr_of_asteroids := _count_asteroids()
		if nr_of_asteroids == 0:
			check_for_asteroids = false
			emit_signal("world_clear")
