class_name StringSelector
extends ConditionSelector

func select(context) -> Variant:
	return get_string(context)

func get_string(context) -> String:
	return ""
