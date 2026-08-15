class_name SurfaceInstance
extends Node2D

@export var definition: SurfaceDefinition
@export var grid_position: Vector2i

@export var animation: ColorRect

@export var blocks_vision: bool = false
@export var remaining_turns: int = 0

@export var effect: EffectDefinition

func _init(
	surface_definition: SurfaceDefinition,
	cell: Vector2i
) -> void:
	definition = surface_definition

	grid_position = cell
	blocks_vision = surface_definition.blocks_vision
	remaining_turns = definition.duration

	effect = surface_definition.effect_definition

	animation = ColorRect.new()
	animation.color = surface_definition.color
	animation.size = Vector2(32, 32)
	animation.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animation.position = Vector2(cell) * 32
	add_child(animation)
