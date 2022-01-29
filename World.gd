extends Node2D

signal world_clear

var check_for_asteroids := false

var Asteroid = preload("res://asteroid/asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start(nr_asteroids: int):
	for _i in range(nr_asteroids):
		var asteroid = Asteroid.instance()
		$Path2D/PathFollow2D.offset = randi()
		var pos = $Path2D/PathFollow2D.position
		var dir = $Path2D/PathFollow2D.transform.y
		asteroid.start(-1, pos, dir.rotated(rand_range(-PI/3, PI/3)))

		get_parent().add_child(asteroid)

	check_for_asteroids = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if check_for_asteroids:
		var nr_of_asteroids := get_tree().get_nodes_in_group("asteroids").size()
		if nr_of_asteroids == 0:
			check_for_asteroids = false
			emit_signal("world_clear")
