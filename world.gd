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
@export var ai_system: AISystem = AISystem.new()

@onready var inventory_ui:InventoryUI = InventoryUI.new()
@onready var collector: InputCollector = InputCollector.new()
@onready var hud: HUD = HUD.new()
@onready var container_ui: ContainerUI = ContainerUI.new()

var turn := 0

var _moving_unit: Being = null

var obstacles: Array[Obstacle] = [
	Obstacle.new_at(Vector2i(1,3)),
	Obstacle.new_at(Vector2i(3,1)),
	Obstacle.new_at(Vector2i(2,1)),
	Obstacle.new_at(Vector2i(0,4))
]

func _ready():
	grid_service.setup(tilemap)
	path_service.setup(Vector2i(20,20),Vector2(32,32),obstacles)
	preview_service.setup(grid_service)
	path_system.setup(path_service)
	grid_system.setup(path_service)
	preview_system.setup(path_system,grid_system,preview_service)
	movement_system.setup(grid_system, grid_service)
	cursor_system.setup(grid_service,grid_system,player)
	skill_system.setup(grid_system,cursor_system)
	ai_system.setup(path_system,grid_system)

	add_child(collector)
	add_child(preview_service)
	add_child(movement_system)
	add_child(register_system)
	add_child(inventory_ui)
	add_child(hud)
	add_child(container_ui)
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
	hud.setup(player)
	_add_test_items()

	turn_system.turn_started.connect(_on_turn_started)
	hud.end_turn_pressed.connect(turn_system.end_turn)
	movement_system.move_finished.connect(_on_move_finished)
	collector.mouse_moved.connect(cursor_system.on_mouse_moved)
	collector.primary_clicked.connect(cursor_system.on_primary_clicked)
	cursor_system.cursor_updated.connect(_update_preview)
	cursor_system.primary_click.connect(_excecute_action)
	register_service.update.connect(register_system.update_logs)
	combat_system.register_action.connect(register_service.register_event)
	ai_system.final_decition.connect(_analice_decition)

	_create_chest()
	create_obstacles()
	turn_system.start()

func _analice_decition(entity: Being, action: ActionDefinition) -> void:
	if action is AttackAction:
		combat_system.attack(entity, action.target)
	elif action is MoveAction:
		var to: Array[Vector2i] = [action.position]
		_moving_unit = entity
		movement_system.move_unit(entity, to)
		return
	turn_system.end_turn()

func _on_turn_started(entity: Being):
	VisionSystem.update(entity.vision, entity.c_position, grid_system)
	if entity is Player:
		_refresh_fog(entity.vision)
	if entity is Enemy:
		ai_system.analice(entity)
		return
	hud.setup(entity)

func _refresh_fog(vision: VisionComponent) -> void:
	fog.update_vision(vision.visible_tiles, vision.revealed_tiles)

func _on_move_finished() -> void:
	if _moving_unit is Player:
		VisionSystem.update(player.vision, player.c_position, grid_system)
		_refresh_fog(player.vision)
	if _moving_unit is Enemy:
		turn_system.end_turn()

func _update_preview(cell: CursorState):
	if !movement_system.is_moving and cell.hovered_entity == null:
		preview_system.update_preview(player,cell.grid_position)
	else:
		preview_system.clear()

func _excecute_action(state: CursorState):
	var objetive = state.hovered_entity
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
		) <= player.stats.range:
			combat_system.attack(player, objetive)
	elif objetive is Entity:
		if hud._current_entity.turn.action_points > 0:
			hud.spend_action(1)
			combat_system.attack(player, objetive)
	elif objetive == null:
		_move_player()

func _move_player():
	if movement_system.is_moving:
		movement_system.stop_move()
		return

	if hud._current_entity.turn.movement_points <= 0:
		return

	var path = preview_system.get_preview()
	if path.is_empty():
		return

	var steps_to_use: Array[Vector2i]
	if player.combating:
		steps_to_use = [path[0]]
	else:
		var max_steps = mini(path.size(), player.turn.movement_points)
		steps_to_use = path.slice(0, max_steps)

	_moving_unit = player
	movement_system.move_unit(player, steps_to_use)
	
	for i in steps_to_use.size():
		await movement_system.move_finished
		hud.spend_movement(1)
	preview_system.clear()

func create_obstacles():
	for obs in obstacles:
		obs.blocks_vision = true
		var rect := ColorRect.new()

		rect.color = Color.DARK_RED
		rect.size = Vector2(32,32)
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

		rect.position = (
			Vector2(obs.c_position.grid_position) * 32
		)

		add_child(rect)
		grid_system.register_entity(obs)

func _create_chest() -> void:
	var chest := Chest.new()
	chest.entity_name = "Cofre"
	chest.chest_name = "Cofre del Tesoro"
	var chest_pos := Vector2i(5, 4)
	chest.c_position.grid_position = chest_pos
	grid_system.register_entity(chest)

	var club := load("res://Data/Items/club_iron.tres") as ItemDefinition
	var herb := load("res://Data/Items/herb_health.tres") as ItemDefinition
	chest.inventory.add_item(club, 1)
	chest.inventory.add_item(herb, 3)

	grid_system.register_entity(chest)

	var chest_visual := Sprite2D.new()
	chest_visual.texture = load("res://sprites/chest/Chest.png")
	chest_visual.position = Vector2(chest_pos) * Vector2(32, 32) + Vector2(16, 16)
	add_child(chest_visual)

func _add_test_items() -> void:
	var club := load("res://Data/Items/club_iron.tres") as ItemDefinition
	var herb := load("res://Data/Items/herb_health.tres") as ItemDefinition
	var orb := load("res://Data/Items/orb_mystic.tres") as ItemDefinition

	player.inventory.add_item(club, 1)
	player.inventory.add_item(herb, 5)
	player.inventory.add_item(orb, 3)
