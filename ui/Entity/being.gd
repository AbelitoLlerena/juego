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

func end_turn() -> void:
	HealthSystem.end_turn(self)
	EffectSystem.end_turn(self)

	if stats.var_health != 0:
		var amount := int(stats.var_health)
		if amount >= 0:
			HealthSystem.heal(health, amount)
		else:
			HealthSystem.apply_damage(health, -amount)

	if stats.var_energy != 0:
		var amount := int(stats.var_energy)
		if amount >= 0:
			HealthSystem.restore_energy(energy, amount)
		else:
			HealthSystem.spend_energy(energy, -amount)

	stats.morale = clamp(stats.morale + stats.var_morale, 0.0, 1.0)
	stats.stress = clamp(stats.stress + stats.var_stress, 0.0, 1.0)
	stats.hungry = clamp(stats.hungry + stats.var_hungry, 0.0, 1.0)
	stats.thirst = clamp(stats.thirst + stats.var_thirst, 0.0, 1.0)
	stats.pain = clamp(stats.pain + stats.var_pain, 0.0, 1.0)
	stats.fatigue = clamp(stats.fatigue + stats.var_fatigue, 0.0, 1.0)
