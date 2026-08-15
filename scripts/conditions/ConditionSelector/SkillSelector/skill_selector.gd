class_name SkillSelector
extends ConditionSelector

func select(context) -> Variant:
	return get_skill(context)

func get_skill(context) -> SkillDefinition:
	return null

#CurrentSkillSelector
#TriggeredSkillSelector
