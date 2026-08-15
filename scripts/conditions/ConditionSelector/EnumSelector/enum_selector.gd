class_name EnumSelector
extends ConditionSelector

func select(context) -> Variant:
	return get_enum(context)

func get_enum(context) -> int:
	return 0
