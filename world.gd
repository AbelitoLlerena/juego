extends Node2D

@onready var tilemap = $Ground
@onready var player = $Player
@onready var label = $Label

@onready var grid_service = $Services/GridService
@onready var path_service = $Services/PathfindingService
@onready var preview_service = $Services/PathPreviewService

@onready var grid_system = $Systems/GridSystem
@onready var path_system = $Systems/PathfindingSystem
@onready var movement_system = $Systems/MovementSystem
@onready var turn_system = $Systems/TurnSystem
@onready var preview_system = $Systems/PathPreviewSystem

var turn := 0
var hover: Vector2i = Vector2i.ZERO

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
	path_system.setup(path_service)
	preview_service.setup(grid_service)
	preview_system.setup(path_system,preview_service)
	movement_system.setup(grid_system, grid_service)
	
	player.grid_position = grid_service.world_to_grid(player.global_position)
	grid_system.register_entity(player)
	turn_system.register(player)
	
	movement_system.move_finished.connect(turn_system.end_turn)
	turn_system.turn_started.connect(_on_turn_started)

	turn_system.start()

func _on_turn_started(entity: Player):
	turn += 1
	label.text = "Turno: %d" % turn
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var cell = grid_service.world_to_grid(get_global_mouse_position())

		if !movement_system.is_moving and cell != hover:
			hover = cell
			preview_system.update_preview(player,cell)

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
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
			Vector2(obs.grid_position) * 32
		)

		add_child(rect)
		grid_system.register_entity(obs)
