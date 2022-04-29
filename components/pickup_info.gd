extends Resource
class_name PickupInfo

enum PickupId {
	COIN = 1
	BLASTER_SPREAD = 2
	BLASTER_REPEAT = 3
	BOMB = 4
}


export(Texture) var texture: Texture = null
export(int) var hframes := 1
export(int) var vframes := 1
export(int) var frame := 0

export(int) var id: int

func _init(p_pickup_id = 0, p_texture = null, p_hframes = 1, p_vframes = 1, p_frame = 0):
	id = p_pickup_id
	texture = p_texture
	hframes = p_hframes
	vframes = p_vframes
	frame = p_frame