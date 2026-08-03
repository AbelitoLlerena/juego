class_name ContainsCondition
extends ConditionDefinition

@export var collection_selector: CollectionSelector
@export var value_selector: ConditionSelector

func check(context) -> bool:
	return collection_selector.get_collection(context).has(
		value_selector.select(context)
	)
