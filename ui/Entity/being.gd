class_name Being
extends Entity

@export var energy : EnergyComponent
@export var inventory : InventoryComponent
@export var equipment : EquipmentComponent
@export var skills : SkillComponent
@export var faction : FactionComponent
@export var experience : ExperienceComponent
@export var turn : TurnComponent
@export var vision : VisionComponent
@export var effect : EffectComponent
@export var status : StatusComponent

func _init() -> void:
	super._init()

	energy = EnergyComponent.new()
	inventory = InventoryComponent.new()
	equipment = EquipmentComponent.new()
	skills = SkillComponent.new()
	faction = FactionComponent.new()
	experience = ExperienceComponent.new()
	turn = TurnComponent.new()
	vision = VisionComponent.new()
	effect = EffectComponent.new()
	status = StatusComponent.new()

func on_ground(grid: GridSystem) -> void:
	var surface := grid.get_surface(c_position.grid_position)
	if surface == null:
		return
	if surface.status_type < 0:
		return
	status.apply(
		surface.status_type,
		surface.status_stacks,
		surface.status_duration
	)
