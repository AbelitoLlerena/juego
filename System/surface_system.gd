class_name SurfaceSystem
extends Node

enum SurfaceType {
	FIRE,
	MUD,
	POISON_CLOUD,
	POISON_PUDDLE,
	SMOKE,
	WATER_PUDDLE,
	WATER_VAPOR
}

static var SURFACE_MAP: Dictionary = {
	SurfaceType.FIRE: FireSurfaceDefinition.new(),
	SurfaceType.MUD: MudSurfaceDefinition.new(),
	SurfaceType.POISON_CLOUD: PoisonCloudSurfaceDefinition.new(),
	SurfaceType.POISON_PUDDLE: PoisonPuddleSurfaceDefinition.new(),
	SurfaceType.SMOKE: SmokeSurfaceDefinition.new(),
	SurfaceType.WATER_PUDDLE: WaterPuddleSurfaceDefinition.new(),
	SurfaceType.WATER_VAPOR: WaterVaporSurfaceDefinition.new(),
}

@onready var _grid_system: GridSystem

signal emit_event(event: SurfaceEvent)

func setup(grid_system: GridSystem) -> void:
	_grid_system = grid_system

func create(
	definition: SurfaceDefinition,
	cell: Vector2i
) -> void:
	var current := _grid_system.get_surface(cell)

	if current != null:
		var reaction := current.definition.on_element(
			definition
		)

		if reaction != null:
			_react(cell, reaction)
			return
		else:
			remove(current)

	_force_create(definition,cell)

func remove(
	surface: SurfaceInstance
):
	_grid_system.unregister_surface(surface.grid_position)

	var entity: Being = _grid_system.get_entity(surface.grid_position)

	if entity != null and entity is Being:
		entity_out(entity, surface)

	var event := RemoveSurfaceEvent.new()
	event.surface = surface
	emit_event.emit(event)

func entity_enter(
	entity: Being,
	surface: SurfaceInstance
):
	EffectSystem.add_effect(
		entity.effect,
		surface.effect
	)

	surface.definition.on_enter(surface,entity)

func entity_out(
	entity: Being,
	surface: SurfaceInstance
):
	var instance = entity.effect.effects.filter(
		func get_instance_of(effect: EffectInstance):
			return effect.definition == surface.definition.effect_definition
	)

	EffectSystem.remove_effect(
		entity.effect,
		instance
	)

	surface.definition.on_exit(surface,entity)

func end_turn() -> void:
	for surface: SurfaceInstance in _grid_system.surfaces.values():
		# Duración infinita
		if surface.remaining_turns >= 0:
			surface.remaining_turns -= 1

			if surface.remaining_turns <= 0:
				remove(surface)

func _apply_reaction(
	cell: Vector2i,
	reaction: SurfaceReaction
) -> void:
	remove(_grid_system.get_surface(cell))

	if reaction.replace_with >= 0:
		_force_create(SURFACE_MAP[reaction.replace_with], cell)

	if reaction.damage > 0:
		var entity: Being = _grid_system.get_entity(cell)

		if entity != null:
			var event := DealDamageEvent.new()
			event.amount = reaction.damage
			event.target = entity
			#emit_event.emit(event)

func _force_create(
	definition: SurfaceDefinition,
	cell: Vector2i
) -> void:
	var instance := SurfaceInstance.new(
		definition,
		cell
	)

	_grid_system.register_surface(instance)

	var entity: Being = _grid_system.get_entity(cell)

	if entity != null and entity is Being:
		entity_enter(entity, instance)

	var event := CreateSurfaceEvent.new()
	event.surface = instance
	emit_event.emit(event)

func _react(start_cell: Vector2i, reaction: SurfaceReaction) -> void:
	if not reaction.propagate:
		_apply_reaction(start_cell, reaction)
		return

	#var start_surface := _grid_system.get_surface(start_cell)
	var start_definition := _grid_system.get_surface(start_cell).definition

	var queue: Array[Vector2i] = [start_cell]
	var visited := { start_cell: true }

	while queue.size() > 0:
		var cell: Vector2i = queue.pop_front()

		_apply_reaction(cell, reaction)

		for new_cell in AreaService.circle(cell, 1):
			if visited.has(new_cell):
				continue

			var surface := _grid_system.get_surface(new_cell)
			if surface == null or surface.definition != start_definition:
				continue

			visited[new_cell] = true
			queue.append(new_cell)
