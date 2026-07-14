class_name FactionComponent
extends Resource

enum Faction {
	PLAYER,
	ALLY,
	ENEMY,
	NEUTRAL
}

@export var faction: Faction = Faction.PLAYER
