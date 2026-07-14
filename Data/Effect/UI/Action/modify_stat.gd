class_name ModifyStatAction
extends EffectAction

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
