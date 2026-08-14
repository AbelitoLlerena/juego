class_name ClubIronItem
extends WeaponItem

func _init() -> void:
	id = &"club_iron"
	name = "Garrote de hierro"
	description = "Un garrote rudimentario pero efectivo. Golpea con fuerza bruta."
	icon = preload("res://sprites/items/Club01.png")
	weight = 3.5
	rarity = ItemDefinition.Rarity.COMMON

	stats = {
		StatsComponent.Stat.STRENGTH: 3,
		StatsComponent.Stat.PHYSICAL_DAMAGE: 4
	}
