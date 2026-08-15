class_name StatsComponent
extends Resource


enum Stat {
	# Atributos
	STRENGTH,
	AGILITY,
	INTELLIGENCE,
	CONSTITUTION,

	# Recursos
	HEALTH,
	MORALE,
	STRESS,
	HUNGER,
	THIRST,
	PAIN,
	CORRUPTION,
	FATIGUE,

	# Ataque
	PHYSICAL_DAMAGE,
	ATTACK_POWER,
	MAGICAL_POWER,
	RANGE,
	CRIT_CHANCE,
	CRIT_BONUS,
	WEAK_CHANCE,
	PRECISION,
	ARMOR_PENETRATION,
	MAGIC_PENETRATION,
	CRIT_MULTIPLIER,
	LIFE_STEAL,
	COUNTERATTACK_CHANCE,
	COMBO_CHANCE,
	COMBO_DAMAGE,
	COMBO_MAX,

	# Defensa
	ARMOR,
	SHIELD,
	BLOCK_CHANCE,
	DODGE_CHANCE,
	DAMAGE_REFLECTION,
	TENACITY,
	DAMAGE_REDUCTION,

	# Resistencias
	RESIST_PHYSICAL,
	RESIST_MENTAL,
	RESIST_FIRE,
	RESIST_ICE,
	RESIST_HOLY,
	RESIST_DARK,
	RESIST_POISON,
	RESIST_BLEED,
	RESIST_CONTROL,
	RESIST_MOVEMENT,

	# Regeneraciones
	HEALTH_RESTORATION,
	HEALING_EFFICIENCY,

	# Variación por turno
	VAR_HEALTH,
	VAR_THIRST,
	VAR_HUNGER,
	VAR_PAIN,
	VAR_MORALE,
	VAR_STRESS,
	VAR_FATIGUE,
}

const MAPPER_RESISTENCE: Dictionary[DamageType.Type,Stat] = {
	DamageType.Type.PHISICAL: Stat.RESIST_PHYSICAL,
	DamageType.Type.FIRE: Stat.RESIST_FIRE,
	DamageType.Type.ICE: Stat.RESIST_ICE,
	DamageType.Type.HOLY: Stat.RESIST_HOLY,
	DamageType.Type.DARK: Stat.RESIST_DARK,
	DamageType.Type.POISON: Stat.RESIST_POISON,
}

const STAT_DISPLAY_NAMES: Dictionary[Stat,StringName] = {
	Stat.STRENGTH: "Fuerza",
	Stat.AGILITY: "Agilidad",
	Stat.INTELLIGENCE: "Inteligencia",
	Stat.CONSTITUTION: "Constitución",

	Stat.HEALTH: "Salud",
	Stat.MORALE: "Moral",
	Stat.STRESS: "Estrés",
	Stat.HUNGER: "Hambre",
	Stat.THIRST: "Sed",
	Stat.PAIN: "Dolor",
	Stat.CORRUPTION: "Corrupción",
	Stat.FATIGUE: "Fatiga",

	Stat.PHYSICAL_DAMAGE: "Daño físico",
	Stat.ATTACK_POWER: "Poder de ataque",
	Stat.MAGICAL_POWER: "Poder mágico",
	Stat.RANGE: "Alcance",
	Stat.CRIT_CHANCE: "Probabilidad de crítico",
	Stat.CRIT_BONUS: "Bonificación de crítico",
	Stat.WEAK_CHANCE: "Probabilidad de golpe débil",
	Stat.PRECISION: "Precisión",
	Stat.ARMOR_PENETRATION: "Penetración de armadura",
	Stat.MAGIC_PENETRATION: "Penetración mágica",
	Stat.CRIT_MULTIPLIER: "Multiplicador de crítico",
	Stat.LIFE_STEAL: "Robo de vida",
	Stat.COUNTERATTACK_CHANCE: "Probabilidad de contraataque",
	Stat.COMBO_CHANCE: "Probabilidad de combo",
	Stat.COMBO_DAMAGE: "Daño de combo",
	Stat.COMBO_MAX: "Combo máximo",

	Stat.ARMOR: "Armadura",
	Stat.SHIELD: "Poder de bloqueo",
	Stat.BLOCK_CHANCE: "Probabilidad de bloqueo",
	Stat.DODGE_CHANCE: "Probabilidad de esquiva",
	Stat.DAMAGE_REFLECTION: "Reflejo de daño",
	Stat.TENACITY: "Tenacidad",
	Stat.DAMAGE_REDUCTION: "Reducción de daño",

	Stat.RESIST_PHYSICAL: "Resistencia física",
	Stat.RESIST_MENTAL: "Resistencia mental",
	Stat.RESIST_FIRE: "Resistencia al fuego",
	Stat.RESIST_ICE: "Resistencia al hielo",
	Stat.RESIST_HOLY: "Resistencia sagrada",
	Stat.RESIST_DARK: "Resistencia oscura",
	Stat.RESIST_POISON: "Resistencia al veneno",
	Stat.RESIST_BLEED: "Resistencia al sangrado",
	Stat.RESIST_CONTROL: "Resistencia al control",
	Stat.RESIST_MOVEMENT: "Resistencia al movimiento",

	Stat.HEALTH_RESTORATION: "Regeneración de salud",
	Stat.HEALING_EFFICIENCY: "Eficiencia de curación",

	Stat.VAR_HEALTH: "Variación de salud",
	Stat.VAR_THIRST: "Variación de sed",
	Stat.VAR_HUNGER: "Variación de hambre",
	Stat.VAR_PAIN: "Variación de dolor",
	Stat.VAR_MORALE: "Variación de moral",
	Stat.VAR_STRESS: "Variación de estrés",
	Stat.VAR_FATIGUE: "Variación de fatiga",
}

var STAT_BASE_VALUES: Dictionary[Stat,float] = {
	Stat.STRENGTH: 10,
	Stat.AGILITY: 10,
	Stat.INTELLIGENCE: 10,
	Stat.CONSTITUTION: 10,

	Stat.HEALTH: 100,
	Stat.MORALE: 1.0,
	Stat.STRESS: 0.0,
	Stat.HUNGER: 0.0,
	Stat.THIRST: 0.0,
	Stat.PAIN: 0.0,
	Stat.CORRUPTION: 0.0,
	Stat.FATIGUE: 0.0,

	Stat.PHYSICAL_DAMAGE: 5,
	Stat.ATTACK_POWER: 1,
	Stat.MAGICAL_POWER: 1,
	Stat.RANGE: 1,
	Stat.CRIT_CHANCE: 0.25,
	Stat.CRIT_BONUS: 0.5,
	Stat.WEAK_CHANCE: 0.05,
	Stat.PRECISION: 0.90,
	Stat.ARMOR_PENETRATION: 0.0,
	Stat.MAGIC_PENETRATION: 0.05,
	Stat.CRIT_MULTIPLIER: 0.5,
	Stat.LIFE_STEAL: 0.0,
	Stat.COUNTERATTACK_CHANCE: 0.25,
	Stat.COMBO_CHANCE: 0.0,
	Stat.COMBO_DAMAGE: 0.1,
	Stat.COMBO_MAX: 5,

	Stat.ARMOR: 2,
	Stat.SHIELD: 10,
	Stat.BLOCK_CHANCE: 0.05,
	Stat.DODGE_CHANCE: 0.05,
	Stat.DAMAGE_REFLECTION: 0.0,
	Stat.TENACITY: 0.05,
	Stat.DAMAGE_REDUCTION: 0.0,

	Stat.RESIST_PHYSICAL: 0,
	Stat.RESIST_MENTAL: 0,
	Stat.RESIST_FIRE: 0,
	Stat.RESIST_ICE: 0,
	Stat.RESIST_HOLY: 0,
	Stat.RESIST_DARK: 0,
	Stat.RESIST_POISON: 0,
	Stat.RESIST_BLEED: 0,
	Stat.RESIST_CONTROL: 0,
	Stat.RESIST_MOVEMENT: 0,

	Stat.HEALTH_RESTORATION: 0.1,
	Stat.HEALING_EFFICIENCY: 0.05,

	Stat.VAR_HEALTH: 0.0,
	Stat.VAR_THIRST: 0.025,
	Stat.VAR_HUNGER: 0.2,
	Stat.VAR_PAIN: 0.0,
	Stat.VAR_MORALE: 0.0,
	Stat.VAR_STRESS: 0.0,
	Stat.VAR_FATIGUE: 0.01,
}

var stats: Dictionary[Stat,float]

var attack_damage: Dictionary[DamageType.Type,float]

func _init() -> void:
	stats = STAT_BASE_VALUES.duplicate()
	attack_damage[DamageType.Type.PHISICAL] = STAT_BASE_VALUES[
		Stat.PHYSICAL_DAMAGE
	]

func get_stat(stat: Stat) -> Variant:
	return stats.get(stat, null)

func get_base_stat(stat: Stat) -> Variant:
	return STAT_BASE_VALUES.get(stat, null)

func get_stat_name(stat: Stat) -> String:
	return STAT_DISPLAY_NAMES.get(stat, "Desconocida")

func get_resistence_at(type: DamageType.Type) -> float:
	if !MAPPER_RESISTENCE.has(type):
		return 0
	return stats[MAPPER_RESISTENCE[type]]

func modify_base_stat(stat: Stat, amount: float) -> void:
	STAT_BASE_VALUES[stat] += amount
	stats[stat] += amount

func modify_stat(stat: Stat, amount: float) -> void:
	stats[stat] += amount

func set_base_stat(stat: Stat, value: float) -> void:
	var difference = value - STAT_BASE_VALUES[stat]
	STAT_BASE_VALUES[stat] = value
	stats[stat] += difference

func set_stat(stat: Stat, value: float) -> void:
	stats[stat] = value
