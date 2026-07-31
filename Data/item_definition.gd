class_name ItemDefinition
extends Resource

enum ItemType { EQUIPMENT, CONSUMABLE, MATERIAL }
enum SlotType { NONE, WEAPON, HELMET, ARMOR, BOOTS, GLOVES, ACCESSORY }
enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

@export var id: StringName
@export var name: String
@export var description: String
@export var icon: Texture2D
@export var weight: float
@export var item_type: ItemType
@export var slot_type: SlotType = SlotType.NONE
@export var max_stack: int = 1
@export var rarity: Rarity = Rarity.COMMON
@export var stats: Dictionary = {}
@export var use_action: StringName = &""
@export var use_value: int = 0

func is_equipment() -> bool:
	return item_type == ItemType.EQUIPMENT

func is_consumable() -> bool:
	return item_type == ItemType.CONSUMABLE

func is_material() -> bool:
	return item_type == ItemType.MATERIAL

func is_stackable() -> bool:
	return max_stack > 1

func get_stat(stat_name: StringName) -> float:
	return stats.get(stat_name, 0.0)
