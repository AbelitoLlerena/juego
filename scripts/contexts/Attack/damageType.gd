class_name DamageType

enum Type {
	#base
	PHISICAL,
	TRUE,
	
	#elemental
	FIRE,
	ICE,
	POISON,
	DARK,
	HOLY
}

static func is_damage_phisical(type: Type) -> bool:
	return type in [
		Type.PHISICAL, 
		Type.POISON
	]

static func is_damage_magical(type: Type) -> bool:
	return type in [
		Type.FIRE, 
		Type.ICE,
		Type.DARK, 
		Type.HOLY, 
	]
