class_name HealthBar3D
extends Node2D

var _bg: ColorRect
var _fill: ColorRect
var _label: Label
var _width: float = 32.0
var _height: float = 4.0

func _init() -> void:
	_bg = ColorRect.new()
	_bg.color = Color(0.2, 0.2, 0.2, 0.8)
	_bg.size = Vector2(_width, _height)
	_bg.position = Vector2(-_width / 2, -_height - 2)
	add_child(_bg)

	_fill = ColorRect.new()
	_fill.color = Color(0.8, 0.1, 0.1)
	_fill.size = Vector2(_width, _height)
	_fill.position = Vector2(-_width / 2, -_height - 2)
	add_child(_fill)

	_label = Label.new()
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.position = Vector2(-_width / 2, -_height - 18)
	_label.size = Vector2(_width, 14)
	_label.add_theme_font_size_override("font_size", 11)
	add_child(_label)

func update_bar(current: int, maximum: int) -> void:
	_label.text = "%d/%d" % [current, maximum]
	if maximum <= 0:
		_fill.size.x = 0
		return
	var ratio := clampf(float(current) / float(maximum), 0.0, 1.0)
	_fill.size.x = _width * ratio

	if ratio > 0.6:
		_fill.color = Color(0.1, 0.8, 0.1)
	elif ratio > 0.3:
		_fill.color = Color(0.9, 0.7, 0.1)
	else:
		_fill.color = Color(0.8, 0.1, 0.1)
