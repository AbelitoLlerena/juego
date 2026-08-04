class_name HUD
extends CanvasLayer

signal end_turn_pressed

var _ap_label: Label
var _mp_label: Label
var _ip_label: Label
var _end_turn_btn: Button
var _turn_label: Label
var _hp_label: Label
var _hp_bar: ProgressBar

var _current_entity: Being = null

func _init() -> void:
	layer = 5

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	panel.offset_top = -52
	panel.offset_left = 200
	panel.offset_right = -200
	panel.offset_bottom = -4
	add_child(panel)

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.12, 0.9)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", style)

	var layout := HBoxContainer.new()
	layout.add_theme_constant_override("separation", 20)
	layout.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_child(layout)

	var hp_box := VBoxContainer.new()
	hp_box.custom_minimum_size = Vector2(120, 0)
	hp_box.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_child(hp_box)

	_hp_label = Label.new()
	_hp_label.add_theme_font_size_override("font_size", 12)
	_hp_label.add_theme_color_override("font_color", Color.WHITE)
	_hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hp_label.text = "HP: 0/0"
	hp_box.add_child(_hp_label)

	_hp_bar = ProgressBar.new()
	_hp_bar.custom_minimum_size = Vector2(120, 14)
	_hp_bar.show_percentage = false
	_hp_bar.max_value = 100
	_hp_bar.value = 100

	var hp_bg := StyleBoxFlat.new()
	hp_bg.bg_color = Color(0.45, 0.05, 0.05)
	hp_bg.corner_radius_top_left = 3
	hp_bg.corner_radius_top_right = 3
	hp_bg.corner_radius_bottom_left = 3
	hp_bg.corner_radius_bottom_right = 3
	_hp_bar.add_theme_stylebox_override("background", hp_bg)

	var hp_fill := StyleBoxFlat.new()
	hp_fill.bg_color = Color(0.2, 0.8, 0.3)
	hp_fill.corner_radius_top_left = 3
	hp_fill.corner_radius_top_right = 3
	hp_fill.corner_radius_bottom_left = 3
	hp_fill.corner_radius_bottom_right = 3
	_hp_bar.add_theme_stylebox_override("fill", hp_fill)

	hp_box.add_child(_hp_bar)

	var sep1 := VSeparator.new()
	layout.add_child(sep1)

	_ap_label = Label.new()
	_ap_label.add_theme_font_size_override("font_size", 14)
	_ap_label.add_theme_color_override("font_color", Color(0.4, 0.8, 1.0))
	_ap_label.text = "AP: 0/0"
	layout.add_child(_ap_label)

	_mp_label = Label.new()
	_mp_label.add_theme_font_size_override("font_size", 14)
	_mp_label.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5))
	_mp_label.text = "MP: 0/0"
	layout.add_child(_mp_label)

	_ip_label = Label.new()
	_ip_label.add_theme_font_size_override("font_size", 14)
	_ip_label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.3))
	_ip_label.text = "IP: 0/0"
	layout.add_child(_ip_label)

	var sep2 := VSeparator.new()
	layout.add_child(sep2)

	_end_turn_btn = Button.new()
	_end_turn_btn.text = "Terminar Turno"
	_end_turn_btn.custom_minimum_size = Vector2(140, 30)
	_end_turn_btn.add_theme_font_size_override("font_size", 12)
	_end_turn_btn.pressed.connect(_on_end_turn_pressed)
	layout.add_child(_end_turn_btn)

func setup(entity: Player) -> void:
	_current_entity = entity
	if is_instance_valid(_current_entity) and _current_entity.health.health_changed.is_connected(_on_health_changed):
		_current_entity.health.health_changed.disconnect(_on_health_changed)
	_current_entity.health.health_changed.connect(_on_health_changed)
	_refresh()

func _on_health_changed(_current: int, _maximum: int) -> void:
	_refresh()

func _refresh() -> void:
	if _current_entity == null:
		return

	var t := _current_entity.turn
	_ap_label.text = "AP: %d/%d" % [t.action_points, t.max_action_points]
	_mp_label.text = "MP: %d/%d" % [t.movement_points, t.max_movement_points]
	_ip_label.text = "IP: %d/%d" % [t.inventory_points, t.max_inventory_points]

	var h := _current_entity.health
	_hp_bar.max_value = h.max_health
	_hp_bar.value = h.health
	_hp_label.text = "HP: %d/%d" % [h.health, h.max_health]

func spend_action(points: int = 1) -> void:
	if _current_entity == null:
		return
	_current_entity.turn.action_points = max(0, _current_entity.turn.action_points - points)
	_refresh()
	_check_auto_end()

func spend_movement(points: int = 1) -> void:
	if _current_entity == null:
		return
	_current_entity.turn.movement_points = max(0, _current_entity.turn.movement_points - points)
	_refresh()
	_check_auto_end()

func spend_inventory(points: int = 1) -> void:
	if _current_entity == null:
		return
	_current_entity.turn.inventory_points = max(0, _current_entity.turn.inventory_points - points)
	_refresh()
	_check_auto_end()

func has_points() -> bool:
	if _current_entity == null:
		return false
	var t := _current_entity.turn
	return t.action_points > 0 or t.movement_points > 0 or t.inventory_points > 0

func _check_auto_end() -> void:
	if not has_points():
		end_turn_pressed.emit()

func _on_end_turn_pressed() -> void:
	end_turn_pressed.emit()
