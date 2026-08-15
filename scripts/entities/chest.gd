class_name Chest
extends Thing

@export var inventory: InventoryComponent
@export var chest_name: String = "Cofre"

func _init() -> void:
	super._init()
	inventory = InventoryComponent.new()
	inventory.capacity = 20
