class_name FactionSystem
extends RefCounted

static func get_relation(
	faction_1:FactionComponent,
	faction_2:FactionComponent
) -> SkillTargetType.SkillTargetFilter:
	#if faction_1.faction == faction_2.faction:
		#return SkillTargetType.SkillTargetFilter.ALLY
	return SkillTargetType.SkillTargetFilter.ENEMY
