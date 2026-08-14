class_name ItemDefinition
extends Resource

enum Rarity { 
	COMMON, 
	UNCOMMON, 
	RARE, 
	EPIC, 
	LEGENDARY
}

@export var id: StringName
@export var name: String
@export var description: String
@export var icon: Texture2D
@export var weight: float = -1
@export var max_stack: int = 1
@export var rarity: Rarity = Rarity.COMMON
@export var price: int = 0

func is_stackable() -> bool:
	return max_stack > 1
