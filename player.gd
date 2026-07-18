class_name Player
extends Node2D

@export var effect: EffectComponent
@export var energy: EnergyComponent
@export var equipment: EquipmentComponent
@export var experience: ExperienceComponent
@export var faction: FactionComponent
@export var health: HealthComponent
@export var inventory: InventoryComponent
#@export var position: PositionComponent
@export var skill: SkillComponent
@export var stats: StatsComponent
@export var turn: TurnComponent
@export var vision: VisionComponent

var grid_position : Vector2i = Vector2i.ZERO
var alert: bool = false
