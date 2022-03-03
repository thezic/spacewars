extends State

export(Color) var meter_color := Color(0, 0, 255, 0.5)

func _enter_state(ctx, _data):
	ctx.shield.is_shielded = false
	ctx.shield.shield_sprite.visible = false
	ctx.shield.shield_energy_meter.visible = true
	ctx.shield.shield_energy_meter.tint_progress = meter_color


func _state_physics_process(ctx, delta):
	ctx.shield_energy += ctx.shield.shield_reload * delta
	if ctx.shield_energy >= ctx.shield.shield_energy:
		transition("ShieldFull")


func _handle_event_activate_shield(_context, data: Dictionary):
	pass
	print("Activate shield event " + str(data))
	transition("ShieldActive")
