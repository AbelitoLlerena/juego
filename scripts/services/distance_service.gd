class_name DistanceService
extends RefCounted

static func distance(from: Vector2i, to: Vector2i) -> int:
	return abs(from.x - to.x) + abs(from.y - to.y)
