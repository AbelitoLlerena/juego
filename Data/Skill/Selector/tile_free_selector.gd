class_name TileFreeSelector
extends SkillTileSelector

func casting(
	caster: Being,
	skill: SkillInstance,
	cursor: CursorSystem
) -> Array[Vector2i]:
	cursor.push_condition(CellFreeCondition.new())
	await cursor.primary_click

	var tiles = [cursor.state.grid_position]
	cursor.pop_condition()

	return tiles
