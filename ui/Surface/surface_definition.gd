class_name SurfaceDefinition
extends Resource

@export var surface_name: String
@export var color: Color

@export var blocks_vision := false
@export var movement_cost := 1.0
@export var duration := -1

@export var effect_definition: EffectDefinition
@export var element: DamageType.Type

@export var reactions: Dictionary[SurfaceSystem.SurfaceType,SurfaceReaction] = {}

func on_enter(
	surface: SurfaceInstance, 
	entity: Entity
) -> void:
	pass

func on_exit(
	surface: SurfaceInstance, 
	entity: Entity
) -> void:
	pass

func on_element(
	surface: SurfaceDefinition,
) -> SurfaceReaction:
	for surface_type in reactions.keys():
		if SurfaceSystem.SURFACE_MAP[surface_type] == surface:
			return reactions[surface_type]

	return null
