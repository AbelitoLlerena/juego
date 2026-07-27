extends Node2D

@onready var tilemap = $Ground
@onready var player: Player = $Player
@onready var label = $Label

@onready var grid_service = $Services/GridService
@onready var path_service = $Services/PathfindingService
@onready var preview_service = $Services/PathPreviewService

@onready var grid_system = $Systems/GridSystem
@onready var path_system = $Systems/PathfindingSystem
@onready var movement_system = $Systems/MovementSystem
@onready var turn_system = $Systems/TurnSystem
@onready var preview_system = $Systems/PathPreviewSystem

@onready var register_system: RegisterSystem
@onready var register_service := RegisterService.new()
@onready var cursor_system:CursorSystem = CursorSystem.new()
@onready var combat_system:CombatSystem = CombatSystem.new()

@onready var collector:InputCollector = InputCollector.new()

var turn := 0

var obstacles: Array[Obstacle] = [
	Obstacle.new_at(Vector2i(1,3)),
	Obstacle.new_at(Vector2i(3,1)),
	Obstacle.new_at(Vector2i(2,1)),
	Obstacle.new_at(Vector2i(0,4))
]

func _ready():
	create_obstacles()
	player.initialice()
	register_system = RegisterSystem.new(register_service)

	grid_service.setup(tilemap)
	path_service.setup(Vector2i(20,20),Vector2(32,32),obstacles)
	path_system.setup(path_service)
	preview_service.setup(grid_service)
	preview_system.setup(path_system,preview_service)
	movement_system.setup(grid_system, grid_service)
	cursor_system.setup(grid_service,grid_system)
	add_child(collector)
	add_child(register_system)
	register_system.position = Vector2(20, 480)
	
	player.c_position.grid_position = grid_service.world_to_grid(player.global_position)
	grid_system.register_entity(player)
	turn_system.register(player)
	
	movement_system.move_finished.connect(turn_system.end_turn)
	turn_system.turn_started.connect(_on_turn_started)
	collector.mouse_moved.connect(cursor_system.on_mouse_moved)
	collector.primary_clicked.connect(cursor_system.on_primary_clicked)
	cursor_system.cursor_updated.connect(_update_preview)
	cursor_system.primary_click.connect(_move_player)
	register_service.update.connect(register_system.update_logs)
	combat_system.register_action.connect(register_service.register_event)

	turn_system.start()

func _on_turn_started(entity: Player):
	turn += 1
	label.text = "Turno: %d" % turn

func _update_preview(cell: CursorState):
	if !movement_system.is_moving and cell.hovered_entity == null:
		preview_system.update_preview(player,cell.grid_position)

func _move_player():
	if movement_system.is_moving:
		movement_system.stop_move()

	else:
		var path = preview_system.get_preview()
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
