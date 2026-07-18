class_name StatsComponent
extends Resource

#atributos
@export var strength:int = 10
@export var agility:int = 10
@export var intelligence:int = 10
@export var constitution:int = 10

#recursos
@export var health:int = 100
@export var mana:int = 50
@export var stamina:int = 80

@export var morale:int = 100
@export var stress:int = 0

@export var heat:int = 0
@export var thirst:int = 0
@export var corruption:int = 0
@export var fatigue:int = 0

#ataque
@export var base_physical_damage:int = 5
@export var base_magical_damage:int = 0
@export var true_damage:int = 0
@export var range:int = 1

@export var crit_chance:float = 0.05
@export var crit_bonus:float = 0.5
@export var weak_chance:float = 0.05
@export var precision:float = 0.90

@export var armor_penetration:float = 0
@export var magic_penetration:float = 0.05

@export var life_steal:float = 0
@export var energy_steal:float = 0

@export var opportunity_attack_chance:int = 5
@export var combo_chance:int = 0
@export var combo_damage:int = 5
@export var combo_max:int = 5

#defenza
@export var Armor:int = 5
@export var shield:int = strength
@export var block_chance:int = 5
@export var dodge_chance:int = 5
@export var damage_reflection:int = 5
@export var tenacity:int = 5
@export var damage_reduction:int = 5

#resistencia
@export var resistances := {
	"physical":0,
	"mental":0,
	"fire":0,
	"ice":0,
	"holy":0,
	"dark":0,
	"poison":0,
	"bleed":0,
	"control":0,
	"movement":0
}
