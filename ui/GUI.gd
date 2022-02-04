extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var score_label := $Score

# Called when the node enters the scene tree for the first time.
func _ready():
	Score.connect("score_updated", self, "update_score")


func update_score(value):
	score_label.text = str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
