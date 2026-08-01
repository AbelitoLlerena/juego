class_name TileFreeSelector
extends SkillSelector

func casting(
	caster_position: Vector2i,
	caster_faction: FactionComponent,
	cursor: CursorSystem
) -> Array[Vector2i]:
	cursor.push_condition(CellFreeCondition.new())
	await cursor.primary_click

	var tiles = [cursor.state.grid_position]
	cursor.pop_condition()

	return tiles
