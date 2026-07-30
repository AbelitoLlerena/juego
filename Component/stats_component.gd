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
@export var shield:int = strength
@export var block_chance:float = 0.05
@export var dodge_chance:float = 0.05
@export var damage_reflection:float = 0
@export var tenacity:float = 0.05
@export var damage_reduction:float = 0

#resistencia
@export var resistances := {
	"physical":0,
	"magical":0,
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

#regeneraciones
@export var health_restoration: float = 0.1
@export var healing_efficiency: float = 0.05
@export var energy_regeneration:float = 0.2
@export var energing_efficiency:float = 0.1

@export var variance:Dictionary[String,float] = {
	"health": 0,
	"energy": 0,
	"thirst": 0.025,
	"hungry": 0.2,
	"pain": 0,
	"morale": 0,
	"stress": 0,
	"fatigue": 0.01,
}
