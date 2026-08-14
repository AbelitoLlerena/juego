class_name ArmorItem
extends EquipmentItem

const ARMOR_SLOT = [
	EquipmentSlot.HELMET,
	EquipmentSlot.ARMOR,
	EquipmentSlot.GLOVES,
	EquipmentSlot.BOOTS,
]

@export var armor: int = 1

func _init(type: EquipmentSlot) -> void:
	super._init()
	assert(type in ARMOR_SLOT, "Tipo de armadura incorrecto")
	equipment_type = type
