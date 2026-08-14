class_name TeleportRule
extends SkillRule

func  _init() -> void:
	var exist := ExistCondition.new()
	exist.entity_selector = EntitySelector.new()

	condition = NotCondition.new()
	condition.condition = exist

	action = SkillTeleportEvent.new()
