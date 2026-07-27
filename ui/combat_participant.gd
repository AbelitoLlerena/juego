class_name CombatParticipant
extends RefCounted

var name: String = ""

# Componentes (referencias)
var stats: StatsComponent
var health: HealthComponent
var equipment: EquipmentComponent
var effects: EffectComponent
var faction: FactionComponent
var position: PositionComponent
var energy: EnergyComponent

func _init(entity:Being) -> void:
	name = entity.entity_name

	stats = entity.stats
	health = entity.health
	equipment = entity.equipment
	effects = entity.effect
	faction = entity.faction
	position = entity.position_component
	energy = entity.energy
