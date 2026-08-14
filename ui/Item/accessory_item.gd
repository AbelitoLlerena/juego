class_name AccessoryItem
extends EquipmentItem

const ACCESSORY_SLOT = [
	EquipmentSlot.RING,
	EquipmentSlot.BELT,
	EquipmentSlot.NECKLACE,
	EquipmentSlot.EARRING
]

func _init(type: EquipmentSlot) -> void:
	super._init()
	assert(type in ACCESSORY_SLOT, "Tipo de accesorio incorrecto")
	equipment_type = type
