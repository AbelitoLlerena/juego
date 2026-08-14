class_name CircleSelector
extends SkillTileSelector

var _radius: int

func  _init(radius: int) -> void:
	_radius = radius

func casting(
	caster: Being,
	skill: SkillInstance,
	cursor: CursorSystem
) -> Array[Vector2i]:
	var accepted := await await_targeting(cursor)
	if not accepted:
		return []

	return AreaService.circle(
		cursor.state.grid_position,
		_radius
	)

func preview_tiles(
	_caster: Being,
	_skill: SkillInstance,
	cursor: CursorSystem
) -> Array[Vector2i]:
	return AreaService.circle(
		cursor.state.grid_position,
		_radius
	)

func preview_color() -> Color:
	return Color(1.0, 0.45, 0.1, 0.95)
