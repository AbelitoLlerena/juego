class_name GridService
extends Node

var _tile_map: TileMapLayer

func setup(map: TileMapLayer):
	_tile_map = map

func world_to_grid(world_position: Vector2) -> Vector2i:
	if _tile_map == null:
		push_error("GridService: TileMap no configurado")
		return Vector2i.ZERO

	return _tile_map.local_to_map(
		_tile_map.to_local(world_position)
	)

func grid_to_world(grid_position: Vector2i) -> Vector2:
	if _tile_map == null:
		push_error("GridService: TileMap no configurado")
		return Vector2.ZERO

	return _tile_map.to_global(
		_tile_map.map_to_local(grid_position)
	)
