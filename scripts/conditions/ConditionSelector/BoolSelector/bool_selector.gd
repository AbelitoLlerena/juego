class_name BoolSelector
extends ConditionSelector

func select(context) -> Variant:
	return get_bool(context)

func get_bool(context) -> bool:
	return false

#IsAliveSelector
#
#CanMoveSelector
#
#CanAttackSelector
#
#CanCastSelector
#
#HasLOSSelector
#
#TileWalkableSelector
#
#TileOccupiedSelector
#
#TileVisibleSelector
#
#CursorReachableSelector
