class_name TileFreeSelector
extends SkillTileSelector

func casting(
	caster: Being,
	skill: SkillInstance,
	cursor: CursorSystem
) -> Array[Vector2i]:
	cursor.push_condition(CellFreeCondition.new())
	var accepted := await await_targeting(cursor)
	if not accepted:
		cursor.pop_condition()
		return []

	var tiles: Array[Vector2i] = [cursor.state.grid_position]
	cursor.pop_condition()
	return tiles

func preview_tiles(
	_caster: Being,
	_skill: SkillInstance,
	cursor: CursorSystem
) -> Array[Vector2i]:
	if not cursor.state.is_valid:
		return []
	return [cursor.state.grid_position]

func preview_color() -> Color:
	return Color(0.3, 0.9, 1.0, 0.95)
