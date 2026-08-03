class_name ExistCondition
extends ConditionDefinition

@export var entity_selector: EntitySelector

func check(context) -> bool:
	return entity_selector.get_entity(context) != null
