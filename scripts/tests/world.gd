extends Node2D
@onready var tilemap = $Ground
@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var fog: FogOverlay = $Fog

@onready var grid_service: GridService = GridService.new()
@onready var path_service: PathfindingService = PathfindingService.new()
@onready var preview_service: PathPreviewService = PathPreviewService.new()
@onready var register_service: RegisterService = RegisterService.new()

@onready var grid_system: GridSystem = GridSystem.new()
@onready var path_system: PathfindingSystem = PathfindingSystem.new()
@onready var movement_system: MovementSystem = MovementSystem.new()
@onready var turn_system: TurnSystem = TurnSystem.new()
@onready var preview_system: PathPreviewSystem = PathPreviewSystem.new()
@onready var register_system: RegisterSystem = RegisterSystem.new(register_service)
@onready var cursor_system: CursorSystem = CursorSystem.new()
@onready var combat_system: CombatSystem = CombatSystem.new()
@onready var skill_system: SkillSystem = SkillSystem.new()
@onready var ai_system: AISystem = AISystem.new()
@onready var effect_system: EffectSystem = EffectSystem.new()
@onready var animation_system: AnimationSystem = AnimationSystem.new()
@onready var surface_system: SurfaceSystem = SurfaceSystem.new()

@onready var inventory_ui:InventoryUI = InventoryUI.new()
@onready var collector: InputService = InputService.new()
@onready var hud: HUD = HUD.new()
@onready var container_ui: ContainerUI = ContainerUI.new()
@onready var character_panel: CharacterPanelUI = CharacterPanelUI.new()
@onready var surface_label: Label = _create_surface_label()
@onready var object_label: Label = _create_object_label()

var turn := 0

@export var map_size: Vector2i = Vector2i(20, 20)
@export var obstacle_cells: Array[Vector2i] = [
	Vector2i(1,3),
	Vector2i(3,1),
	Vector2i(2,1),
	Vector2i(0,4)
]

@export var surface_config: Dictionary[Vector2i,SurfaceDefinition] = {
	Vector2i(4,2): SmokeSurfaceDefinition.new(),
	Vector2i(6,3): WaterVaporSurfaceDefinition.new(),
	Vector2i(8,2): PoisonCloudSurfaceDefinition.new(),
	Vector2i(7,6): PoisonPuddleSurfaceDefinition.new(),
	Vector2i(3,6): WaterPuddleSurfaceDefinition.new(),
	Vector2i(5,5): MudSurfaceDefinition.new(),
	Vector2i(9,3): FireSurfaceDefinition.new(),
	Vector2i(4,6): MudSurfaceDefinition.new(),
}

@export var door_list: Array[Dictionary] = [
	{"cell": Vector2i(11,3), "target_scene": "res://Scence/world2.tscn", "name": "Puerta del bosque"}
]

@export var barrel_cells: Array[Vector2i] = [
	Vector2i(10,6),
	Vector2i(12,5)
]

@export var barrel_radius: int = 2
@export var barrel_damage: int = 5
@export var chest_cell: Vector2i = Vector2i(5, 4)

var obstacles: Array[Obstacle] = []

func _ready():
	grid_service.setup(tilemap)
	path_service.setup(map_size,Vector2(32,32),obstacles)
	preview_service.setup(grid_service)
	path_system.setup(path_service)
	grid_system.setup(path_service)
	preview_system.setup(path_system,grid_system,preview_service)
	movement_system.setup(grid_system, grid_service, animation_system)
	cursor_system.setup(grid_service,grid_system,player)
	skill_system.setup(grid_system,cursor_system)
	ai_system.setup(path_system,grid_system)
	surface_system.setup(grid_system)

	add_child(collector)
	add_child(preview_service)
	add_child(movement_system)
	add_child(animation_system)
	add_child(register_system)
	add_child(inventory_ui)
	add_child(hud)
	add_child(container_ui)
	add_child(character_panel)
	register_system.position = Vector2(20, 240)

	player.initialice()
	enemy.initialice()
	player.c_position.grid_position = grid_service.world_to_grid(player.global_position)
	enemy.c_position.grid_position = grid_service.world_to_grid(enemy.global_position)
	grid_system.register_entity(player)
	grid_system.register_entity(enemy)
	turn_system.register(player)
	turn_system.register(enemy)

	inventory_ui.setup(player)
	character_panel.setup(player)
	_add_test_items()

	turn_system.turn_started.connect(_on_turn_started)
	turn_system.turn_finished.connect(_end_turn)
	hud.end_turn_pressed.connect(turn_system.end_turn)
	movement_system.move_finished.connect(_update_vision)
	collector.mouse_moved.connect(cursor_system.on_mouse_moved)
	collector.primary_clicked.connect(cursor_system.on_primary_clicked)
	cursor_system.cursor_updated.connect(_update_preview)
	cursor_system.cursor_updated.connect(_update_surface_label)
	cursor_system.cursor_updated.connect(_update_object_label)
	cursor_system.primary_click.connect(_excecute_action)
	register_service.update.connect(register_system.update_logs)
	combat_system.register_action.connect(register_service.register_event)
	ai_system.final_decition.connect(_analice_decition)
	surface_system.emit_event.connect(_analice_event)
	skill_system.emit_event.connect(_analice_event)
	player.turn.update_points.connect(hud.refresh)

	_build_obstacles()
	_build_surfaces()

	_create_chest()
	create_obstacles()
	create_doors()
	create_barrels()

	hud.refresh(player.turn)
	turn_system.start()

func _end_turn(entity):
	for ent in turn_system.turn_order:
		ent.end_turn()
		effect_system.end_turn(ent)
	movement_system.stop_movement_event()
	surface_system.end_turn()

func _create_surface(surface: SurfaceInstance) -> void:
	add_child(surface)

func _remove_surface(surface: SurfaceInstance) -> void:
	remove_child(surface)

func _analice_event(event: EventDefinition):
	if event is SkillActionEvent:
		if event is SkillAttackEvent \
		or event is SkillHealEvent:
			event.system = combat_system
		elif event is SkillApplyEffectEvent:
			event.system = effect_system
		elif event is SkillTeleportEvent:
			event.system = movement_system
	elif event is CombatEvent:
		event.system = combat_system
	elif event is SurfaceEvent:
		if event is CreateSurfaceEvent:
			_create_surface(event.surface)
		elif event is RemoveSurfaceEvent:
			_remove_surface(event.surface)
	elif event is MoveEvent:
		event.system = movement_system
	elif event is TurnEvent:
		event.system = turn_system

	await event.execute()

func _analice_decition(event: EventDefinition) -> void:
	await _analice_event(event)

	if event is not EndTurnEvent:
		_on_turn_started(turn_system.current_entity)

func _build_obstacles() -> void:
	for cell in obstacle_cells:
		obstacles.append(Obstacle.new_at(cell))

func _build_surfaces() -> void:
	for cell in surface_config.keys():
		var definition := surface_config[cell]
		surface_system.create(definition, cell)

func _on_turn_started(entity: Being):
	_update_vision(entity)
	if entity is Player:
		hud.refresh(entity.turn)
		_refresh_fog(entity.vision)
	if entity is Enemy:
		ai_system.analice(entity)

func _update_vision(unit: Being):
	VisionSystem.update(unit.vision,unit.c_position,grid_system)

func _refresh_fog(vision: VisionComponent) -> void:
	fog.update_vision(vision.visible_tiles, vision.revealed_tiles)

func _update_preview(cell: CursorState):
	if !movement_system.is_moving and cell.hovered_entity == null:
		preview_system.update_preview(player,cell.grid_position)
	else:
		preview_system.clear()

func _create_surface_label() -> Label:
	var label := Label.new()
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	label.visible = false
	label.z_index = 100
	add_child(label)
	return label

func _update_surface_label(state: CursorState) -> void:
	var surface := grid_system.get_surface(state.grid_position)
	if surface == null:
		surface_label.visible = false
		return
	surface_label.text = surface.definition.surface_name
	surface_label.global_position = grid_service.grid_to_world(state.grid_position) + Vector2(0, 24)
	surface_label.visible = true

func _create_object_label() -> Label:
	var label := Label.new()
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	label.visible = false
	label.z_index = 100
	add_child(label)
	return label

func _update_object_label(state: CursorState) -> void:
	var target = state.hovered_entity
	if target is Thing and target.entity_name != "":
		object_label.text = target.entity_name
		object_label.global_position = grid_service.grid_to_world(state.grid_position) + Vector2(0, 24)
		object_label.visible = true
	else:
		object_label.visible = false

func _excecute_action(state: CursorState):
	var objetive = state.hovered_entity
	var event: EventDefinition
	if objetive is Player:
		return
	elif objetive is Chest:
		container_ui.setup(player.inventory, objetive.inventory, objetive.chest_name)
		container_ui.open()
	elif objetive is Enemy:
		if objetive.health.is_dead:
			container_ui.setup(player.inventory, objetive.inventory, "Cadáver de " + objetive.entity_name)
			container_ui.open()
		elif DistanceService.distance(
			player.c_position.grid_position,
			state.grid_position
		) <= player.stats.get_stat(StatsComponent.Stat.RANGE) and player.turn.action_points > 0:
			event = AttackEvent.new()
			event.attacker = player
			event.target = objetive
			_analice_decition(event)
	elif objetive is Thing and objetive.openable != null:
		_try_open_door(objetive)
	elif objetive is Entity and \
		DistanceService.distance(
			player.c_position.grid_position,
			state.grid_position
		) <= player.stats.range and player.turn.action_points > 0:
			event = AttackEvent.new()
			event.attacker = player
			event.target = objetive
			_analice_decition(event)
			_check_explosion(objetive)
	elif objetive == null:
		_move_player()

func _try_open_door(door: Thing) -> void:
	if door.openable.opened:
		return
	if DistanceService.distance(
		player.c_position.grid_position,
		door.c_position.grid_position
	) > 1:
		register_service.register_event("Debes estar al lado de " + door.openable.display_name + " para abrirla")
		return
	if player.turn.action_points <= 0:
		return
	player.turn.consuming_point(TurnComponent.TypePoint.ACTION)
	door.openable.opened = true
	register_service.register_event("Abres: " + door.openable.display_name)
	if door.openable.target_scene != "" and ResourceLoader.exists(door.openable.target_scene):
		get_tree().change_scene_to_file(door.openable.target_scene)

func _check_explosion(target) -> void:
	if target is Thing and target.attackable != null and target.health.current <= 0:
		_explode(target)

func _explode(barrel: Thing) -> void:
	var cell := barrel.c_position.grid_position
	var radius := barrel.attackable.explosion_radius
	var damage := barrel.attackable.explosion_damage

	grid_system.unregister_entity(barrel)
	var visual = barrel.get_meta("visual", null)
	if visual != null:
		visual.queue_free()

	var tiles := AreaService.circle(cell, radius)
	for tile in tiles:
		var e := grid_system.get_entity(tile)
		if e is Being:
			HealthSystem.apply_damage(e.health, damage)
			effect_system.add_effect_event(e.effect, StatusEffects.burn())

	surface_system.create(FireSurfaceDefinition.new(),cell)
	register_service.register_event("¡Boom! El barril de fuego explota")

func _move_player():
	if movement_system.is_moving:
		var event = StopMovementEvent.new()
		_analice_decition(event)
		return

	var path = preview_system.get_preview()
	if path.is_empty():
		return

	var event: EventDefinition
	if player.combating:
		event = WalkEvent.new()
		event.entity = player
		event.destination = path[0]
	else:
		event = FollowPathEvent.new()
		event.entity = player
		event.path = path

	_analice_decition(event)
	preview_system.clear()

func create_obstacles():
	for obs in obstacles:
		obs.blocks_vision = true
		_create_thing_rect(obs, Color.DARK_RED)
		grid_system.register_entity(obs)

func create_doors():
	for config in door_list:
		var door := Door.new_at(
			config.get("cell", Vector2i.ZERO),
			config.get("target_scene", ""),
			config.get("name", "Puerta")
		)
		_create_thing_sprite(door, "res://assets/sprites/objects/door.png")
		grid_system.register_entity(door)

func create_barrels():
	for cell in barrel_cells:
		var barrel := Barrel.new_at(cell, barrel_radius, barrel_damage)
		_create_thing_sprite(barrel, "res://assets/sprites/objects/barrel.png")
		grid_system.register_entity(barrel)

func _create_thing_rect(thing: Thing, color: Color) -> void:
	var rect := ColorRect.new()
	rect.color = color
	rect.size = Vector2(32, 32)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.position = Vector2(thing.c_position.grid_position) * 32
	add_child(rect)
	thing.set_meta("visual", rect)

func _create_thing_sprite(thing: Thing, texture_path: String) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = load(texture_path)
	sprite.position = Vector2(thing.c_position.grid_position) * Vector2(32, 32) + Vector2(16, 16)
	add_child(sprite)
	thing.set_meta("visual", sprite)

func _create_chest() -> void:
	var chest := Chest.new()
	chest.entity_name = "Cofre"
	chest.chest_name = "Cofre del Tesoro"
	var chest_pos := chest_cell
	chest.c_position.grid_position = chest_pos
	grid_system.register_entity(chest)

	var club := ClubIronItem.new()
	var herb := HerbHealthItem.new()
	chest.inventory.add_item(club, 1)
	chest.inventory.add_item(herb, 3)

	grid_system.register_entity(chest)

	var chest_visual := Sprite2D.new()
	chest_visual.texture = load("res://assets/sprites/chest/Chest.png")
	chest_visual.position = Vector2(chest_pos) * Vector2(32, 32) + Vector2(16, 16)
	add_child(chest_visual)

func _add_test_items() -> void:
	var club := ClubIronItem.new()
	var herb := HerbHealthItem.new()
	var orb := OrbMysticItem.new()

	player.inventory.add_item(club, 1)
	player.inventory.add_item(herb, 5)
	player.inventory.add_item(orb, 3)
