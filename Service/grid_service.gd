class_name GridService
extends RefCounted

var tile_map: TileMapLayer

func setup(map:TileMapLayer):
	tile_map = map

func world_to_grid(pos:Vector2)->Vector2i:
	return tile_map.local_to_map(
		tile_map.to_local(pos)
	)

func grid_to_world(cell:Vector2i)->Vector2:
	return tile_map.to_global(
		tile_map.map_to_local(cell)
	)
