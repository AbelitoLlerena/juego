class_name ModifyStatAction
extends ActionDefinition

enum Stat {
	ATTACK,
	DEFENSE,
	SPEED,
	CRIT,
	MAX_HEALTH
}

@export var stat : Stat
@export var amount : float
@export var permanent := false
