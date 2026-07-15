class_name SkillComponent
extends Node

@export var skills : Array[SkillDefinition]

var cooldowns : Dictionary = {}

func get_skill(id:StringName) -> SkillDefinition:

	for skill in skills:
		if skill.id == id:
			return skill

	return null

func is_on_cooldown(skill:SkillDefinition)->bool:
	return cooldowns.get(skill.id,0) > 0

func trigger_cooldown(skill:SkillDefinition):

	cooldowns[skill.id] = skill.cooldown

func tick():

	for id in cooldowns.keys():
		cooldowns[id] = max(0,cooldowns[id]-1)
