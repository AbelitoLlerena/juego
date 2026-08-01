extends Node2D

@onready var tilemap = $Ground
@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var label = $Label

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

var turn := 0

var obstacles: Array[Obstacle] = [
	Obstacle.new_at(Vector2i(1,3)),
	Obstacle.new_at(Vector2i(3,1)),
	Obstacle.new_at(Vector2i(2,1)),
	Obstacle.new_at(Vector2i(0,4))
]

func _ready():
	create_obstacles()

	grid_service.setup(tilemap)
	path_service.setup(Vector2i(20,20),Vector2(32,32),obstacles)
	preview_service.setup(grid_service)
	path_system.setup(path_service)
	grid_system.setup(path_service)
	preview_system.setup(path_system,grid_system,preview_service)
	movement_system.setup(grid_system, grid_service)
	cursor_system.setup(grid_service,grid_system)
	skill_system.setup(grid_system,cursor_system)
	ai_system.setup(path_system,grid_system)

	add_child(collector)
	add_child(preview_service)
	add_child(movement_system)
	add_child(register_system)
	add_child(inventory_ui)
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
	_add_test_items()

	movement_system.move_finished.connect(turn_system.end_turn)
	turn_system.turn_started.connect(_on_turn_started)
	collector.mouse_moved.connect(cursor_system.on_mouse_moved)
	collector.primary_clicked.connect(cursor_system.on_primary_clicked)
	cursor_system.cursor_updated.connect(_update_preview)
	cursor_system.primary_click.connect(_excecute_action)
	register_service.update.connect(register_system.update_logs)
	combat_system.register_action.connect(register_service.register_event)
	combat_system.end_action.connect(turn_system.end_turn)
	ai_system.final_decition.connect(_analice_decition)

	turn_system.start()

func _analice_decition(entity: Being, action: ActionDefinition) -> void:
	if action is AttackAction:
		combat_system.attack(entity, action.target)
	elif action is MoveAction:
		var to: Array[Vector2i] = [action.position]
		movement_system.move_unit(entity, to)
	else:
		turn_system.end_turn()

func _on_turn_started(entity: Being):
	#print(entity.name)
	VisionSystem.update(entity.vision, entity.c_position, grid_system)
	if entity is Enemy:
		ai_system.analice(entity)
	else:
		turn += 1
		label.text = "Turno: %d" % turn

func _update_preview(cell: CursorState):
	if !movement_system.is_moving and cell.hovered_entity == null:
		preview_system.update_preview(player,cell.grid_position)

func _excecute_action():
	var objetive = cursor_system.state.hovered_entity
	if objetive is Player:
		turn_system.end_turn()
	elif objetive is Entity:
		combat_system.attack(player, objetive)
	if objetive == null:
		_move_player()

func _move_player():
	if movement_system.is_moving:
		movement_system.stop_move()

	else:
		var path = preview_system.get_preview()
		if player.combating:
			movement_system.move_unit(player, [path[0]])
		else:
			movement_system.move_unit(player, path)
		preview_system.clear()

func create_obstacles():
	for obs in obstacles:
		var rect := ColorRect.new()

		rect.color = Color.DARK_RED
		rect.size = Vector2(32,32)
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

		rect.position = (
			Vector2(obs.c_position.grid_position) * 32
		)

		add_child(rect)
		grid_system.register_entity(obs)

func _add_test_items() -> void:
	var club := load("res://Data/Items/club_iron.tres") as ItemDefinition
	var herb := load("res://Data/Items/herb_health.tres") as ItemDefinition
	var orb := load("res://Data/Items/orb_mystic.tres") as ItemDefinition

	player.inventory.add_item(club, 1)
	player.inventory.add_item(herb, 5)
	player.inventory.add_item(orb, 3)
