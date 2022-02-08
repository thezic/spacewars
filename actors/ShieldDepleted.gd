extends "ShieldInactive.gd"

export(Color) var depleted_meter_color := Color(255, 0, 0, 0.5)


func _enter_state(ctx, _data):
	._enter_state(ctx, _data)
	ctx.shield_energy = 0.0
	ctx.shield.shield_energy_meter.tint_progress = depleted_meter_color


func _handle_event_activate_shield(_context, _data):
	pass