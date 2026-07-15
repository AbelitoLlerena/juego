class_name SkillSystem

static func execute(context:SkillContext):
	for rule in context.skill.rules:

		if !rule.enabled:
			continue

		if rule.condition == null or rule.condition.evaluate(context):
			rule.action.execute(context)
