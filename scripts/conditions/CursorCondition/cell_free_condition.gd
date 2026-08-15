class_name CellFreeCondition
extends NotCondition

func  _init() -> void:
	condition = ExistCondition.new()
	condition.entity_selector = HoveredEntitySelector.new()
