extends Node

var Ufo = preload("res://actors/Ufo.tscn")

export var min_time := 10
export var max_time := 20

var level = 1
var ufos = []

onready var timer = $Timer
onready var follower = $Path2D/PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready():
	start_timer()


func start_timer():
	var timeout = rand_range(min_time, max_time)
	timer.wait_time = timeout
	timer.start()
	print("Ufo will spawn in " + str(timeout) + " seconds")


func _on_Timer_timeout():
	var ufo = Ufo.instance()
	follower.offset = randi()
	ufo.start(follower.position)
	add_child(ufo)
	ufo.connect("destroyed", self, "_on_Ufo_destroyed", [ufo])
	ufos.push_back(ufo)
	print("Ufo spawned")


func _on_Ufo_destroyed(ufo):
	print("Ufo destroyed")
	var score = Score.calculate_score_for_ufo(level)
	ufos.erase(ufo)
	print(ufos)
	Score.create_floating_score(score, ufo.position)
	start_timer()


func _on_Game_start_level(nr: int):
	level = nr


func reset():
	for ufo in ufos:
		ufo.destroy(false)
	ufos = []
	start_timer()
