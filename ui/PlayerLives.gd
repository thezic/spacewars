extends GridContainer


export(int) var max_lives := 0
export(Texture) var texture
export(Color) var color

func _enter_tree():
	for child in get_children():
		remove_child(child)

func _ready():
	pass


func update_max_lives(value: int):
	max_lives = value
	for _i in range(max_lives - get_child_count()):
		var rect = TextureRect.new()
		rect.texture = texture
		rect.modulate = color
		rect.visible = false

		add_child(rect)


func update_lives(value: int):
	if value > max_lives:
		update_max_lives(value)

	for i in get_child_count():
		get_child(i).visible = value > i
