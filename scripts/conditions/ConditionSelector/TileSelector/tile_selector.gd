class_name TileSelector
extends ConditionSelector

func select(context) -> Variant:
	return get_tile(context)

func get_tile(context) -> Vector2i:
	return Vector2i.ZERO
