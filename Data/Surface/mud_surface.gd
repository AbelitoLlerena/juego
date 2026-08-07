class_name MudSurfaceDefinition
extends SurfaceDefinition

func _init():
	surface_name = "Barro"
	color = Color(.5,.35,.2)
	movement_cost = 2
	duration = -1
	effect_definition = StatusEffects.slowed()

	var r1 := SurfaceReaction.new()
	r1.replace_with = SurfaceSystem.SurfaceType.SMOKE
	reactions[SurfaceSystem.SurfaceType.FIRE] = r1

	var r2 := SurfaceReaction.new()
	r2.replace_with = SurfaceSystem.SurfaceType.POISON_PUDDLE
	reactions[SurfaceSystem.SurfaceType.POISON_CLOUD] = r2
