class_name StatsComponent
extends Resource

@export var strength:int = 10
@export var agility:int = 10
@export var intelligence:int = 10
@export var constitution:int = 10

@export var base_damage:int = 5

@export var crit_chance:float = 0.05
@export var crit_multiplier:float = 1.5

@export var dodge_chance:float = 0.05

@export var accuracy:float = 0.90

@export var resistances := {
	"physical":0,
	"fire":0,
	"ice":0,
	"lightning":0,
	"poison":0
}
