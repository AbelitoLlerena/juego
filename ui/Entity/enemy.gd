class_name Enemy 
extends Being

@export var ai: AIComponent
@export var max_health: int = 10
var combating: bool = false
var _health_bar: HealthBar3D

func _ready() -> void:
	health.max_health = max_health
	health.health = max_health
	_health_bar = HealthBar3D.new()
	_health_bar.position = Vector2(0, -20)
	add_child(_health_bar)
	health.health_changed.connect(_on_health_changed)
	_update_health_bar()

func initialice() -> void:
	entity_name = "Johny"
	ai = MeleeAI.new()

func _on_health_changed(current: int, maximum: int) -> void:
	_update_health_bar()

func _update_health_bar() -> void:
	if _health_bar != null and health != null:
		_health_bar.update_bar(health.health, health.max_health)
