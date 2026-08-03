class_name TeleportRule
extends SkillRule

func  _init() -> void:
	condition = ExistCondition.new()
	condition.entity_selector = TargetSelector.new()

	action = TeleportAction.new()
