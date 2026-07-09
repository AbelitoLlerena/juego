class_name GridService
extends Node

var tile_map: TileMapLayer
var tile_size: Vector2


func setup(map: TileMapLayer, size: Vector2):
	tile_map = map
	tile_size = size


func world_to_grid(world_position: Vector2) -> Vector2i:
	if tile_map == null:
		push_error("GridService: TileMap no configurado")
		return Vector2i.ZERO

	return tile_map.local_to_map(
		tile_map.to_local(world_position)
	)


func grid_to_world(grid_position: Vector2i) -> Vector2:
	if tile_map == null:
		push_error("GridService: TileMap no configurado")
		return Vector2.ZERO

	return tile_map.to_global(
		tile_map.map_to_local(grid_position)
	)
