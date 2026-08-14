class_name OrbMysticItem
extends MaterialItem

func _init() -> void:
	id = &"orb_mystic"
	name = "Esfera mistica"
	description = "Una esfera que emite un tenue resplandor. Se dice que contiene energia pura."
	icon = preload("res://sprites/items/orb3.png")
	weight = 0.5
	max_stack = 20
	rarity = ItemDefinition.Rarity.COMMON
