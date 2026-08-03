class_name CasterTileSelector
extends TileSelector

func get_tile(context):
	return context.caster.c_position.grid_position
