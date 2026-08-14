class_name EquipmentItem
extends ItemDefinition

enum EquipmentSlot {
	WEAPON,
	HELMET,
	ARMOR,
	BOOTS,
	GLOVES,
	RING,
	NECKLACE,
	BELT,
	EARRING
}

@export var equipment_type: EquipmentSlot
@export var stats: Dictionary[StatsComponent.Stat, float] = {}

func _init() -> void:
	max_stack = 1
