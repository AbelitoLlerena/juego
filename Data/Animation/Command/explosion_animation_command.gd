class_name ExplosionAnimationCommand
extends AnimationCommand

class Burst extends Node2D:
	var radius := 12.0
	var color := Color(1.0, 0.42, 0.08, 0.9)

	func _draw() -> void:
		draw_circle(Vector2.ZERO, radius, color)
		draw_arc(Vector2.ZERO, radius, 0.0, TAU, 20, Color(1, 0.85, 0.4, 0.95), 2.0)


var _tiles: Array[Vector2i]
var _grid_service: GridService
var _duration := 0.35
var _color := Color(1.0, 0.42, 0.08, 0.9)

func _init(
	tiles: Array[Vector2i],
	grid_service: GridService,
	duration := 0.35,
	color := Color(1.0, 0.42, 0.08, 0.9)
) -> void:
	_tiles = tiles
	_grid_service = grid_service
	_duration = duration
	_color = color

func execute(animation_system: AnimationSystem) -> void:
	var host := animation_system.get_parent()
	if host == null or _grid_service == null or _tiles.is_empty():
		return

	var bursts: Array[Burst] = []
	for tile in _tiles:
		var burst := Burst.new()
		burst.color = _color
		burst.z_index = 80
		burst.global_position = _grid_service.grid_to_world(tile)
		burst.scale = Vector2(0.35, 0.35)
		host.add_child(burst)
		bursts.append(burst)

	var tween := animation_system.create_tween()
	tween.set_parallel(true)
	for burst in bursts:
		tween.tween_property(burst, "scale", Vector2(1.8, 1.8), _duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(burst, "modulate:a", 0.0, _duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	await tween.finished

	for burst in bursts:
		if is_instance_valid(burst):
			burst.queue_free()
