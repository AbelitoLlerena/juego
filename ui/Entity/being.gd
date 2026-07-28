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
@export var effects : EffectComponent

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
	effects = EffectComponent.new()
