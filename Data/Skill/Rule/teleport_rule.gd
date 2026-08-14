class_name TeleportRule
extends SkillRule

func  _init() -> void:
	condition = NotCondition.new()
	condition.condition = ExistCondition.new()
	condition.entity_selector = EntitySelector.new()

	action = SkillTeleportEvent.new()
