extends State

var shield_energy: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _enter_state(ctx, _data):
	ctx.shield.is_shielded = true
	ctx.shield.shield_sprite.visible = true
	ctx.shield.shield_energy_meter.visible = true
	ctx.shield_energy = ctx.shield.shield_energy


func _state_physics_process(ctx, delta):
	ctx.shield_energy -= ctx.shield.shield_deplete * delta
	ctx.shield.shield_sprite.modulate = Color(1.5, 1.5, 1.5, 0.8 * (float(ctx.shield_energy) / ctx.shield.shield_energy))

	if ctx.shield_energy <= 0:
		transition("ShieldDepleted")


func _handle_event_deactivate_shield(_context, _data):
	transition("ShieldInactive")


func _handle_event_deplete_shield(_context, _data):
	transition("ShieldDepleted")
