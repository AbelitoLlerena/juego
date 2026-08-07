class_name WaterPuddleSurfaceDefinition
extends SurfaceDefinition

func _init():
	surface_name = "Charco"
	color = Color(.2,.4,.9)
	duration = -1
	effect_definition = EffectDefinition.new()

	var r := SurfaceReaction.new()
	r.replace_with = SurfaceSystem.SurfaceType.WATER_VAPOR
	reactions[SurfaceSystem.SurfaceType.FIRE] = r
