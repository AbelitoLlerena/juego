class_name HerbHealthItem
extends ConsumableItem

func _init() -> void:
	id = &"herb_health"
	name = "Hierba curativa"
	description = "Una hierba con propiedades medicinales. Restaura vida al consumirla."
	icon = preload("res://sprites/items/Herb05.png")
	weight = 0.3
	max_stack = 10
	rarity = ItemDefinition.Rarity.COMMON

	use_action = &"heal"
	use_value = 20
