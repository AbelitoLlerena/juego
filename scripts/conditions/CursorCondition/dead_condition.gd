class_name DeadCondition
extends BoolCondition

func  _init() -> void:
	bool_selector = IsDeadSelector.new()
	bool_selector.entity_selector = HoveredEntitySelector.new()

	expected = true
