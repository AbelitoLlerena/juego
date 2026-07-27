class_name Entity
extends Node

var entity_name: String = ""

@onready var health: HealthComponent
@onready var c_position: PositionComponent
@onready var stats: StatsComponent

func _init() -> void:
	health = HealthComponent.new()
	c_position = PositionComponent.new()
	stats = StatsComponent.new()
