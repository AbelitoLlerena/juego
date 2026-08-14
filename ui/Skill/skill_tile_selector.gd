class_name SkillTileSelector
extends Resource

func casting(
	caster: Being,
	skill: SkillInstance,
	cursor: CursorSystem
) -> Array[Vector2i]:
	return [caster.c_position.grid_position]

func preview_tiles(
	_caster: Being,
	_skill: SkillInstance,
	_cursor: CursorSystem
) -> Array[Vector2i]:
	return []

func preview_color() -> Color:
	return Color(1.0, 0.5, 0.15, 0.9)

func await_targeting(cursor: CursorSystem) -> bool:
	return await cursor.targeting_resolved
