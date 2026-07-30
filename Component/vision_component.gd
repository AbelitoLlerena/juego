class_name VisionComponent
extends Resource

@export var view_distance:int = 8
@export var vision_angle:float = 360

@export var darkvision:bool = false
@export var invisible:bool = false
@export var detect_invisible: bool = false

var visible_entities: Array[Entity] = []
var audible_entities: Array[Being] = []

var visible_tiles: Array[Vector2i] = []
