class_name VisionSystem
extends RefCounted

static func update(vision: VisionComponent, position: PositionComponent, grid: GridSystem) -> void:
	_clear(vision)
	_calculate_visible_tiles(vision, position, grid)
	_calculate_visible_entities(vision, position, grid)
	_calculate_audible_entities(vision, position, grid)
	_accumulate_revealed(vision)

static func _clear(vision: VisionComponent) -> void:
	vision.visible_tiles.clear()
	vision.visible_entities.clear()
	vision.audible_entities.clear()

static func _accumulate_revealed(vision: VisionComponent) -> void:
	for tile in vision.visible_tiles:
		if tile not in vision.revealed_tiles:
			vision.revealed_tiles.append(tile)

static func _calculate_visible_tiles(
	vision: VisionComponent,
	position: PositionComponent,
	grid: GridSystem
) -> void:

	var visible := AreaService.circle(
		position.grid_position,
		vision.view_distance
	)

	_sort_by_distance(visible, position.grid_position)

	var shadows: Array[Vector2i] = []

	for tile in visible:
		if tile in vision.visible_tiles:
			continue

		vision.visible_tiles.append(tile)

		if !grid.blocks_vision(tile):
			continue

		shadows.append_array(
			_cast_shadow(
				vision,
				position.grid_position,
				tile
			)
		)

	for tile in shadows:
		vision.visible_tiles.erase(tile)

static func _sort_by_distance(
	tiles: Array[Vector2i],
	center: Vector2i
) -> void:
	
	tiles.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		var da := DistanceService.distance(center, a)
		var db := DistanceService.distance(center, b)
		return da < db   # true si a va antes que b
	)

static func _cast_shadow(
	vision: VisionComponent,
	origin: Vector2i,
	obstacle: Vector2i
) -> Array[Vector2i]:

	var distance := DistanceService.distance(origin,obstacle)

	if distance <= 0:
		return []

	var direction := obstacle + (obstacle - origin)
	var angle := rad_to_deg(atan(1.0 / distance))

	var shadow := AreaService.cone(
		obstacle,
		direction,
		vision.view_distance - int(distance),
		angle * 2.0
	)

	shadow.erase(obstacle)
	return shadow

static func _calculate_visible_entities(vision: VisionComponent, position: PositionComponent, grid: GridSystem) -> void:
	for tile in vision.visible_tiles:
		var target := grid.get_entity(tile)

		if target == null:
			continue

		if target.c_position.grid_position == position.grid_position:
			continue

		if !_can_see(vision, target):
			continue

		vision.visible_entities.append(target)

static func _calculate_audible_entities(vision: VisionComponent, position: PositionComponent, grid: GridSystem) -> void:
	var area := AreaService.circle(
		position.grid_position,
		vision.view_distance
	)
	
	for tile in area:
		var entity := grid.get_entity(tile)
		if entity is Being:
			vision.audible_entities.append(entity)

static func _can_see(observer: VisionComponent, target: Entity) -> bool:
	if target is Being:
		if target.vision.invisible and !observer.detect_invisible:
			return false

	# oscuridad
	# TODO

	return true
