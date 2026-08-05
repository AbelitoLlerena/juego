class_name HUD
extends CanvasLayer

signal end_turn_pressed

var _ap_label: Label
var _mp_label: Label
var _ip_label: Label
var _end_turn_btn: Button

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

func refresh(turn: TurnComponent) -> void:
	_ap_label.text = "AP: %d/%d" % [turn.action_points, turn.max_action_points]
	_mp_label.text = "MP: %d/%d" % [turn.movement_points, turn.max_movement_points]
	_ip_label.text = "IP: %d/%d" % [turn.inventory_points, turn.max_inventory_points]

	_check_auto_end(turn)

func has_points(turn: TurnComponent) -> bool:
	return turn.action_points > 0 or turn.movement_points > 0 or turn.inventory_points > 0

func _check_auto_end(turn: TurnComponent) -> void:
	if not has_points(turn):
		end_turn_pressed.emit()

func _on_end_turn_pressed() -> void:
	end_turn_pressed.emit()
