class_name TypeCondition
extends ConditionDefinition

@export var selector: EntitySelector
@export var type_name: StringName

func check(context) -> bool:
	var entity := selector.get_entity(context)

	if entity == null:
		return false

	return entity.is_class(type_name)
