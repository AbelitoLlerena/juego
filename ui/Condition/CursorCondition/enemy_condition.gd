class_name IsEnemyCondition
extends EnumCondition

func _init() -> void:
	enum_selector = GetRelationSelector.new()

	enum_selector.source_selector = PlayerSelector.new()
	enum_selector.target_selector = HoveredEntitySelector.new()

	expected = SkillTargetType.SkillTargetFilter.ALLY
