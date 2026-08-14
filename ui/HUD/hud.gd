class_name HUD
extends CanvasLayer

signal end_turn_pressed
signal skill_activated(skill: SkillDefinition)
signal skill_cancel_pressed

const SKILL_SLOT_COUNT := 5

var _ap_label: Label
var _mp_label: Label
var _ip_label: Label
var _end_turn_btn: Button
var _skill_slots: Array[SkillSlotUI] = []
var _being: Being = null

func _init() -> void:
	layer = 5

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	panel.offset_top = -48
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
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	panel.add_theme_stylebox_override("panel", style)

	var layout := HBoxContainer.new()
	layout.add_theme_constant_override("separation", 12)
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

	var skills_row := HBoxContainer.new()
	skills_row.add_theme_constant_override("separation", 4)
	skills_row.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_child(skills_row)

	for i in SKILL_SLOT_COUNT:
		var slot := SkillSlotUI.new()
		slot.set_hotkey(i + 1)
		slot.skill_pressed.connect(_on_skill_pressed)
		skills_row.add_child(slot)
		_skill_slots.append(slot)

	var sep3 := VSeparator.new()
	layout.add_child(sep3)

	_end_turn_btn = Button.new()
	_end_turn_btn.text = "Terminar Turno"
	_end_turn_btn.custom_minimum_size = Vector2(120, 28)
	_end_turn_btn.add_theme_font_size_override("font_size", 12)
	_end_turn_btn.pressed.connect(_on_end_turn_pressed)
	layout.add_child(_end_turn_btn)

func setup_skills(being: Being) -> void:
	_being = being
	var skills := being.skills.skills
	for i in _skill_slots.size():
		var slot := _skill_slots[i]
		if i < skills.size():
			slot.set_skill(skills[i])
		else:
			slot.set_skill(null)
	refresh_skills()

func refresh(turn: TurnComponent) -> void:
	_ap_label.text = "AP: %d/%d" % [turn.action_points, turn.max_action_points]
	_mp_label.text = "MP: %d/%d" % [turn.movement_points, turn.max_movement_points]
	_ip_label.text = "IP: %d/%d" % [turn.inventory_points, turn.max_inventory_points]
	refresh_skills()
	_check_auto_end(turn)

func refresh_skills() -> void:
	if _being == null:
		return
	for slot in _skill_slots:
		slot.refresh(_being)

func set_armed_skill(skill: SkillDefinition) -> void:
	for slot in _skill_slots:
		slot.set_armed(slot.get_skill() == skill and skill != null)

func has_points(turn: TurnComponent) -> bool:
	return turn.action_points > 0 or turn.movement_points > 0 or turn.inventory_points > 0

func _check_auto_end(turn: TurnComponent) -> void:
	if not has_points(turn):
		end_turn_pressed.emit()

func _on_end_turn_pressed() -> void:
	end_turn_pressed.emit()

func _on_skill_pressed(skill: SkillDefinition) -> void:
	skill_activated.emit(skill)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		skill_cancel_pressed.emit()
		return

	if event is InputEventKey:
		var key_event := event as InputEventKey
		if not key_event.pressed or key_event.echo:
			return
		var index := _hotkey_index(key_event.keycode)
		if index < 0 or index >= _skill_slots.size():
			return
		_skill_slots[index].activate()
		get_viewport().set_input_as_handled()

func _hotkey_index(keycode: Key) -> int:
	match keycode:
		KEY_1:
			return 0
		KEY_2:
			return 1
		KEY_3:
			return 2
		KEY_4:
			return 3
		KEY_5:
			return 4
		_:
			return -1
