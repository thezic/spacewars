extends State


func _enter_state(ctx, _data):
	print("Enter Shield full state")
	ctx.shield.shield_energy_meter.visible = false
	ctx.shield.shield_sprite.visible = false
	ctx.shield.is_shielded = false


func _handle_event_activate_shield(_context, data: Dictionary):
	print("Activate shield event " + str(data))
	transition("ShieldActive")
