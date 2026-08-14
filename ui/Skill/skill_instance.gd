class_name SkillInstance
extends Resource

var definition: SkillDefinition

var skill_cast_time: int
var skill_action_cost: int
var skill_range: int

func _init(skill: SkillDefinition):
	definition = skill
	skill_cast_time = skill.cast_time
	skill_action_cost = skill.action_cost
	skill_range = skill.range
