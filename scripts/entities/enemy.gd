class_name Enemy 
extends Being

@export var ai: AIComponent
var combating: bool = false

var _health_bar: HealthBar3D

func _ready() -> void:
	health.max_health = 10
	health.current = 10
	_health_bar = HealthBar3D.new()
	_health_bar.position = Vector2(0, -20)
	add_child(_health_bar)
	health.health_changed.connect(_on_health_changed)
	_update_health_bar()

func initialice() -> void:
	entity_name = "Johny"
	ai = MeleeAI.new()
	inventory.capacity = 10

func _on_health_changed(current: int, maximum: int) -> void:
	_update_health_bar()
	if current <= 0 and not health.is_dead:
		_die()

func _die() -> void:
	health.is_dead = true
	health.is_dead = true
	combating = false
	_health_bar.visible = false
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate = Color(0.5, 0.5, 0.5, 0.7)

func _update_health_bar() -> void:
	if _health_bar != null and health != null:
		_health_bar.update_bar(health.current, health.max_health)
