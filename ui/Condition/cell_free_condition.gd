class_name CellFreeCondition
extends CursorCondition

func  check(state: CursorState) -> bool:
	return state.hovered_entity == null
