class_name AIContext
extends RefCounted

var actor: Enemy

var visible_allies: Array[Enemy] = []
var visible_enemies: Array[Being] = []

var reachable_tiles: Array[Vector2i] = []

var _pathfinding: PathfindingSystem
var _grid: GridSystem
