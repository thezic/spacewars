extends Node

signal score_updated(score)

var score setget _set_score
var bonus := 0

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
	_set_score(0)


func add(value: int):
	_set_score(score + value)


func calculate_score_for_asteroid(size: int, asteroids_in_play: int, level: int):
	# var new_bonus = 2 * asteroids_in_play / pow(2, level) + 1
	var new_bonus = 2.0 + float(asteroids_in_play) / 5
	# print("Score, asteroids in play: " + str(asteroids_in_play) + ", bonus: " + str(new_bonus))
	if new_bonus > bonus:
		bonus = new_bonus
	return (6 - size) * bonus * level
