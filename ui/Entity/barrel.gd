class_name Barrel
extends Thing

static func new_at(cell: Vector2i, radius: int = 2, damage: int = 5) -> Barrel:
	var b := Barrel.new()
	b.entity_name = "Barril de fuego"
	b.attackable = AttackableComponent.new()
	b.attackable.explosion_radius = radius
	b.attackable.explosion_damage = damage
	b.health.max_health = 8
	b.health.current = 8
	b.blocks_vision = false
	b.c_position.grid_position = cell
	return b
