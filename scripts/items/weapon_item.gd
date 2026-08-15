class_name WeaponItem
extends EquipmentItem

@export var damage: Dictionary[DamageType.Type, int]
@export var range_attack: int = 1

func _init() -> void:
	super._init()
	equipment_type = EquipmentSlot.WEAPON
