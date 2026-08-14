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
	skills.tick()
	HealthSystem.end_turn(self)

	var var_health = stats.get_stat(
		StatsComponent.Stat.VAR_HEALTH
	)

	if var_health != 0:
		var amount := int(var_health)
		if amount >= 0:
			HealthSystem.heal(health, amount)
		else:
			HealthSystem.apply_damage(health, -amount)

	stats.set_stat(
	StatsComponent.Stat.MORALE,
	clamp(
		stats.get_stat(StatsComponent.Stat.MORALE)
		+ stats.get_stat(StatsComponent.Stat.VAR_MORALE),
		0.0,
		1.0
	)
)

	stats.set_stat(
		StatsComponent.Stat.STRESS,
		clamp(
			stats.get_stat(StatsComponent.Stat.STRESS)
			+ stats.get_stat(StatsComponent.Stat.VAR_STRESS),
			0.0,
			1.0
		)
	)

	stats.set_stat(
		StatsComponent.Stat.HUNGER,
		clamp(
			stats.get_stat(StatsComponent.Stat.HUNGER)
			+ stats.get_stat(StatsComponent.Stat.VAR_HUNGER),
			0.0,
			1.0
		)
	)

	stats.set_stat(
		StatsComponent.Stat.THIRST,
		clamp(
			stats.get_stat(StatsComponent.Stat.THIRST)
			+ stats.get_stat(StatsComponent.Stat.VAR_THIRST),
			0.0,
			1.0
		)
	)

	stats.set_stat(
		StatsComponent.Stat.PAIN,
		clamp(
			stats.get_stat(StatsComponent.Stat.PAIN)
			+ stats.get_stat(StatsComponent.Stat.VAR_PAIN),
			0.0,
			1.0
		)
	)

	stats.set_stat(
		StatsComponent.Stat.FATIGUE,
		clamp(
			stats.get_stat(StatsComponent.Stat.FATIGUE)
			+ stats.get_stat(StatsComponent.Stat.VAR_FATIGUE),
			0.0,
			1.0
		)
	)
