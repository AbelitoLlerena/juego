class_name PoisonPuddleSurfaceDefinition
extends SurfaceDefinition

func _init():
	surface_name = "Charco venenoso"
	color = Color(.15,.6,.2)
	#effect_definition = StatusEffects.poison()
	effect_definition = EffectDefinition.new()
	duration = 6

	var r1 := SurfaceReaction.new()
	r1.replace_with = SurfaceSystem.SurfaceType.POISON_CLOUD
	r1.propagate = true
	r1.damage = 10
	r1.damage_type = DamageType.Type.FIRE
	reactions[SurfaceSystem.SurfaceType.FIRE] = r1

	var r2 := SurfaceReaction.new()
	r2.replace_with = SurfaceSystem.SurfaceType.POISON_PUDDLE
	reactions[SurfaceSystem.SurfaceType.WATER_PUDDLE] = r2

	var r3 := SurfaceReaction.new()
	r3.replace_with = SurfaceSystem.SurfaceType.POISON_CLOUD
	reactions[SurfaceSystem.SurfaceType.WATER_VAPOR] = r3

	var r4 := SurfaceReaction.new()
	r4.replace_with = SurfaceSystem.SurfaceType.POISON_PUDDLE
	reactions[SurfaceSystem.SurfaceType.MUD] = r4
