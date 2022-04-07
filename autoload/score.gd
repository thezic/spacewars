extends Node

signal score_updated(score)


var score setget _set_score
var bonus := 0
var locked := false

var FloatingScore = preload("res://ui/FloatingScore.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()


func _set_score(value: int) -> void:
	if (value == score):
		return

	score = value
	emit_signal("score_updated", score)


func reset():
	bonus = 0
	locked = false
	_set_score(0)


func add(value: int):
	if locked:
		return

	_set_score(score + value)


func lock():
	locked = true


func calculate_score_for_asteroid(size: int, asteroids_in_play: int, level: int):
	# var new_bonus = 2 * asteroids_in_play / pow(2, level) + 1
	var new_bonus = 2.0 + float(asteroids_in_play) / 5
	# print("Score, asteroids in play: " + str(asteroids_in_play) + ", bonus: " + str(new_bonus))
	if new_bonus > bonus:
		bonus = new_bonus
	return (6 - size) * bonus * level


func calculate_score_for_ufo(level: int):
	return 250 + level * 250


func create_floating_score(value: int, pos: Vector2, add_score = true):
	if locked:
		return

	if add_score:
		add(value)

	var floating_score = FloatingScore.instance()
	add_child(floating_score)
	floating_score.start(str(value), pos)