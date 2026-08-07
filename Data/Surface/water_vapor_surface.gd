class_name WaterVaporSurfaceDefinition
extends SurfaceDefinition

func _init():
	surface_name = "Vapor"
	color = Color(.7,.8,1,.6)
	blocks_vision = true
	duration = 2
	effect_definition = EffectDefinition.new()

	var r := SurfaceReaction.new()
	reactions[SurfaceSystem.SurfaceType.SMOKE] = r
