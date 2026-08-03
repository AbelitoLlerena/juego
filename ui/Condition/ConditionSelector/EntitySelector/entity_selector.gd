class_name EntitySelector
extends ConditionSelector

func select(context) -> Variant:
	return get_entity(context)

func get_entity(context) -> Entity:
	return null
