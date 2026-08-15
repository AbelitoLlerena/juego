class_name AttackStats
extends BaseStatsContext

var precision:float = 0

var armor_penetration:float = 0

var life_steal:float = 0

var damage: Dictionary[DamageType.Type,float] = {
	DamageType.Type.PHISICAL: 0
}
