class_name Surface
extends Thing

enum Type {
	SMOKE,
	WATER_VAPOR,
	POISON_CLOUD,
	POISON_PUDDLE,
	WATER_PUDDLE,
	MUD,
	FIRE
}

@export var type: Type = Type.WATER_PUDDLE
@export var effect_definition: EffectDefinition = null
@export var effect_stacks: int = 0
@export var effect_duration: int = 3

static func new_surface(surface_type: Type, cell: Vector2i) -> Surface:
	var s := Surface.new()
	s.type = surface_type
	s.entity_name = type_name(surface_type)
	s.c_position.grid_position = cell
	s.blocks_vision = surface_type in [
		Type.SMOKE,
		Type.WATER_VAPOR,
		Type.POISON_CLOUD
	]
	s.effect_definition = base_effect(surface_type)
	s.effect_stacks = base_effect_stacks(surface_type)
	return s

static func base_effect(surface_type: Type) -> EffectDefinition:
	match surface_type:
		Type.POISON_PUDDLE, Type.POISON_CLOUD:
			return StatusEffects.poison()
		Type.FIRE:
			return StatusEffects.burn()
		Type.MUD:
			return StatusEffects.slowed()
	return null

static func base_effect_stacks(surface_type: Type) -> int:
	match surface_type:
		Type.POISON_PUDDLE:
			return 5
		Type.POISON_CLOUD:
			return 3
		Type.FIRE:
			return 2
		Type.MUD:
			return 1
	return 0

static func type_name(surface_type: Type) -> String:
	match surface_type:
		Type.SMOKE:
			return "Humo"
		Type.WATER_VAPOR:
			return "Vapor de agua"
		Type.POISON_CLOUD:
			return "Nube de veneno"
		Type.POISON_PUDDLE:
			return "Charco de veneno"
		Type.WATER_PUDDLE:
			return "Charco de agua"
		Type.MUD:
			return "Charco de barro"
		Type.FIRE:
			return "Fuego"
	return "Superficie"

static func type_from_name(type_name: String) -> Type:
	match type_name.to_lower().strip_edges():
		"smoke": return Type.SMOKE
		"water_vapor": return Type.WATER_VAPOR
		"poison_cloud": return Type.POISON_CLOUD
		"poison_puddle": return Type.POISON_PUDDLE
		"water_puddle": return Type.WATER_PUDDLE
		"mud": return Type.MUD
		"fire": return Type.FIRE
	return Type.WATER_PUDDLE

func color() -> Color:
	match type:
		Type.SMOKE:
			return Color(0.5, 0.5, 0.5, 0.7)
		Type.WATER_VAPOR:
			return Color(0.6, 0.8, 1.0, 0.6)
		Type.POISON_CLOUD:
			return Color(0.3, 0.9, 0.3, 0.7)
		Type.POISON_PUDDLE:
			return Color(0.2, 0.6, 0.2, 0.8)
		Type.WATER_PUDDLE:
			return Color(0.3, 0.5, 0.9, 0.8)
		Type.MUD:
			return Color(0.55, 0.4, 0.22, 0.9)
		Type.FIRE:
			return Color(1.0, 0.4, 0.1, 0.9)
	return Color.WHITE
