class_name StatsComponent
extends Resource

#atributos
@export var strength:int = 10
@export var agility:int = 10
@export var intelligence:int = 10
@export var constitution:int = 10

#recursos
@export var health:int = 100
@export var energy:int = 80

@export var morale:float = 1
@export var stress:float = 0

@export var hungry:float = 0
@export var thirst:float = 0

@export var pain:float = 0
@export var corruption:float = 0
@export var fatigue:float = 0

#ataque
@export var base_physical_damage:int = 5
@export var base_magical_damage:int = 0
@export var true_damage:int = 0
@export var range:int = 1

@export var crit_chance:float = 0.25
@export var crit_bonus:float = 0.5
@export var weak_chance:float = 0.05
@export var precision:float = 0.90

@export var armor_penetration:float = 0
@export var magic_penetration:float = 0.05
@export var crit_multiplier:float = 0.5

@export var life_steal:float = 0
@export var energy_steal:float = 0

@export var counterattack_chance:float = 0.25

@export var combo_chance:float = 0
@export var combo_damage:float = 0.1
@export var combo_max:int = 5

#defenza
@export var armor:int = 2
@export var shield:int = 10
@export var block_chance:float = 0.05
@export var dodge_chance:float = 0.05
@export var damage_reflection:float = 0
@export var tenacity:float = 0.05
@export var damage_reduction:float = 0

#resistencias
@export var resist_physical:int = 0
@export var resist_magical:int = 0
@export var resist_mental:int = 0
@export var resist_fire:int = 0
@export var resist_ice:int = 0
@export var resist_holy:int = 0
@export var resist_dark:int = 0
@export var resist_poison:int = 0
@export var resist_bleed:int = 0
@export var resist_control:int = 0
@export var resist_movement:int = 0

#regeneraciones
@export var health_restoration: float = 0.1
@export var healing_efficiency: float = 0.05
@export var energy_regeneration:float = 0.2
@export var energing_efficiency:float = 0.1

#varianza por turno
@export var var_health:float = 0
@export var var_energy:float = 0
@export var var_thirst:float = 0.025
@export var var_hungry:float = 0.2
@export var var_pain:float = 0
@export var var_morale:float = 0
@export var var_stress:float = 0
@export var var_fatigue:float = 0.01

#base stats (sin modificar por equipo)
var _base_strength:int = 10
var _base_agility:int = 10
var _base_intelligence:int = 10
var _base_constitution:int = 10
var _base_base_physical_damage:int = 5
var _base_base_magical_damage:int = 0
var _base_true_damage:int = 0
var _base_crit_chance:float = 0.25
var _base_crit_bonus:float = 0.5
var _base_precision:float = 0.90
var _base_weak_chance:float = 0.05
var _base_armor_penetration:float = 0
var _base_magic_penetration:float = 0.05
var _base_crit_multiplier:float = 0.5
var _base_life_steal:float = 0
var _base_energy_steal:float = 0
var _base_counterattack_chance:float = 0.25
var _base_combo_chance:float = 0
var _base_combo_damage:float = 0.1
var _base_armor:int = 2
var _base_block_chance:float = 0.05
var _base_dodge_chance:float = 0.05
var _base_damage_reflection:float = 0
var _base_tenacity:float = 0.05
var _base_damage_reduction:float = 0
var _base_health_restoration: float = 0.1
var _base_healing_efficiency: float = 0.05
var _base_energy_regeneration:float = 0.2
var _base_energing_efficiency:float = 0.1
var _base_resist_physical:int = 0
var _base_resist_magical:int = 0
var _base_resist_mental:int = 0
var _base_resist_fire:int = 0
var _base_resist_ice:int = 0
var _base_resist_holy:int = 0
var _base_resist_dark:int = 0
var _base_resist_poison:int = 0
var _base_resist_bleed:int = 0
var _base_resist_control:int = 0
var _base_resist_movement:int = 0
var _has_base_stats:bool = false

func save_base_stats() -> void:
	_base_strength = strength
	_base_agility = agility
	_base_intelligence = intelligence
	_base_constitution = constitution
	_base_base_physical_damage = base_physical_damage
	_base_base_magical_damage = base_magical_damage
	_base_true_damage = true_damage
	_base_crit_chance = crit_chance
	_base_crit_bonus = crit_bonus
	_base_precision = precision
	_base_weak_chance = weak_chance
	_base_armor_penetration = armor_penetration
	_base_magic_penetration = magic_penetration
	_base_crit_multiplier = crit_multiplier
	_base_life_steal = life_steal
	_base_energy_steal = energy_steal
	_base_counterattack_chance = counterattack_chance
	_base_combo_chance = combo_chance
	_base_combo_damage = combo_damage
	_base_armor = armor
	_base_block_chance = block_chance
	_base_dodge_chance = dodge_chance
	_base_damage_reflection = damage_reflection
	_base_tenacity = tenacity
	_base_damage_reduction = damage_reduction
	_base_health_restoration = health_restoration
	_base_healing_efficiency = healing_efficiency
	_base_energy_regeneration = energy_regeneration
	_base_energing_efficiency = energing_efficiency
	_base_resist_physical = resist_physical
	_base_resist_magical = resist_magical
	_base_resist_mental = resist_mental
	_base_resist_fire = resist_fire
	_base_resist_ice = resist_ice
	_base_resist_holy = resist_holy
	_base_resist_dark = resist_dark
	_base_resist_poison = resist_poison
	_base_resist_bleed = resist_bleed
	_base_resist_control = resist_control
	_base_resist_movement = resist_movement
	_has_base_stats = true

func get_base_stat(stat_name: String) -> Variant:
	match stat_name:
		"strength": return _base_strength
		"agility": return _base_agility
		"intelligence": return _base_intelligence
		"constitution": return _base_constitution
		"base_physical_damage": return _base_base_physical_damage
		"base_magical_damage": return _base_base_magical_damage
		"true_damage": return _base_true_damage
		"crit_chance": return _base_crit_chance
		"crit_bonus": return _base_crit_bonus
		"precision": return _base_precision
		"weak_chance": return _base_weak_chance
		"armor_penetration": return _base_armor_penetration
		"magic_penetration": return _base_magic_penetration
		"crit_multiplier": return _base_crit_multiplier
		"life_steal": return _base_life_steal
		"energy_steal": return _base_energy_steal
		"counterattack_chance": return _base_counterattack_chance
		"combo_chance": return _base_combo_chance
		"combo_damage": return _base_combo_damage
		"armor": return _base_armor
		"block_chance": return _base_block_chance
		"dodge_chance": return _base_dodge_chance
		"damage_reflection": return _base_damage_reflection
		"tenacity": return _base_tenacity
		"damage_reduction": return _base_damage_reduction
		"health_restoration": return _base_health_restoration
		"healing_efficiency": return _base_healing_efficiency
		"energy_regeneration": return _base_energy_regeneration
		"energing_efficiency": return _base_energing_efficiency
		"resist_physical": return _base_resist_physical
		"resist_magical": return _base_resist_magical
		"resist_mental": return _base_resist_mental
		"resist_fire": return _base_resist_fire
		"resist_ice": return _base_resist_ice
		"resist_holy": return _base_resist_holy
		"resist_dark": return _base_resist_dark
		"resist_poison": return _base_resist_poison
		"resist_bleed": return _base_resist_bleed
		"resist_control": return _base_resist_control
		"resist_movement": return _base_resist_movement
		_: return 0
