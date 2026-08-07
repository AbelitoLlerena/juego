class_name FireSurfaceDefinition
extends SurfaceDefinition

func _init():
	surface_name = "Fuego"
	color = Color(1,.4,.1)
	duration = 3
	effect_definition = StatusEffects.burn()

	var r1 := SurfaceReaction.new()
	r1.replace_with = SurfaceSystem.SurfaceType.WATER_VAPOR
	reactions[SurfaceSystem.SurfaceType.WATER_PUDDLE] = r1

	var r2 := SurfaceReaction.new()
	r2.replace_with = SurfaceSystem.SurfaceType.SMOKE
	reactions[SurfaceSystem.SurfaceType.MUD] = r2

	var r3 := SurfaceReaction.new()
	r3.replace_with = SurfaceSystem.SurfaceType.POISON_CLOUD
	r3.propagate = true
	r3.damage = 10
	r3.damage_type = DamageType.Type.FIRE
	reactions[SurfaceSystem.SurfaceType.POISON_PUDDLE] = r3

	var r4 := SurfaceReaction.new()
	r4.propagate = true
	r4.damage = 10
	r4.damage_type = DamageType.Type.FIRE
	reactions[SurfaceSystem.SurfaceType.POISON_CLOUD] = r4
