class_name Door
extends Thing

static func new_at(cell: Vector2i, target_scene: String, display_name: String = "Puerta") -> Door:
	var d := Door.new()
	d.entity_name = display_name
	d.openable = OpenableComponent.new()
	d.openable.display_name = display_name
	d.openable.target_scene = target_scene
	d.blocks_vision = true
	d.c_position.grid_position = cell
	return d