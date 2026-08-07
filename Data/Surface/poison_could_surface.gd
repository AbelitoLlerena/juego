class_name PoisonCloudSurfaceDefinition
extends SurfaceDefinition

func _init():
	surface_name = "Nube venenosa"
	color = Color(.2,.8,.2,.6)
	duration = 4
	blocks_vision = true
	#effect_definition = StatusEffects.poison()
	effect_definition = EffectDefinition.new()

	var r1 := SurfaceReaction.new()
	r1.propagate = true
	r1.damage_type = DamageType.Type.FIRE
	r1.damage = 10
	reactions[SurfaceSystem.SurfaceType.FIRE] = r1

	var r2 := SurfaceReaction.new()
	r2.replace_with = SurfaceSystem.SurfaceType.POISON_PUDDLE
	reactions[SurfaceSystem.SurfaceType.WATER_PUDDLE] = r2

	var r3 := SurfaceReaction.new()
	r3.replace_with = SurfaceSystem.SurfaceType.POISON_PUDDLE
	reactions[SurfaceSystem.SurfaceType.MUD] = r3
