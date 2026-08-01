class_name TeleportRule
extends SkillRule

func  _init() -> void:
	condition = CellTargetFreeCondition.new()
	action = TeleportAction.new()
