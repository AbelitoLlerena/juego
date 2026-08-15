class_name SmokeSurfaceDefinition
extends SurfaceDefinition

func _init():
	surface_name = "Humo"
	color = Color(.5,.5,.5,.7)
	blocks_vision = true
	duration = 3
	effect_definition = EffectDefinition.new()

	var r := SurfaceReaction.new()
	reactions[SurfaceSystem.SurfaceType.WATER_VAPOR] = r
