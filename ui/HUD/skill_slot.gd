class_name SkillSlotUI
extends PanelContainer

signal skill_pressed(skill: SkillDefinition)

const SLOT_SIZE := Vector2(32, 32)

var _skill: SkillDefinition = null
var _hotkey := 0
var _armed := false

var _icon: TextureRect
var _hotkey_label: Label
var _cost_label: Label
var _cooldown_overlay: ColorRect
var _cooldown_label: Label

func _init() -> void:
	custom_minimum_size = SLOT_SIZE
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	mouse_filter = Control.MOUSE_FILTER_STOP
	clip_contents = true

	var bg := ColorRect.new()
	bg.name = "Background"
	bg.color = Color(0.12, 0.12, 0.15)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	_icon = TextureRect.new()
	_icon.name = "Icon"
	_icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_icon.offset_left = 3
	_icon.offset_top = 3
	_icon.offset_right = -3
	_icon.offset_bottom = -3
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_icon.modulate = Color(1.0, 0.5, 0.15)
	add_child(_icon)

	_hotkey_label = Label.new()
	_hotkey_label.name = "Hotkey"
	_hotkey_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_hotkey_label.offset_left = 2
	_hotkey_label.offset_top = -1
	_hotkey_label.offset_right = 14
	_hotkey_label.offset_bottom = 12
	_hotkey_label.add_theme_font_size_override("font_size", 9)
	_hotkey_label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.9))
	_hotkey_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_hotkey_label.add_theme_constant_override("outline_size", 4)
	_hotkey_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hotkey_label)

	_cost_label = Label.new()
	_cost_label.name = "Cost"
	_cost_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	_cost_label.offset_left = 2
	_cost_label.offset_top = -12
	_cost_label.offset_right = 20
	_cost_label.offset_bottom = -1
	_cost_label.add_theme_font_size_override("font_size", 9)
	_cost_label.add_theme_color_override("font_color", Color(0.4, 0.8, 1.0))
	_cost_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_cost_label.add_theme_constant_override("outline_size", 4)
	_cost_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_cost_label)

	_cooldown_overlay = ColorRect.new()
	_cooldown_overlay.name = "CooldownOverlay"
	_cooldown_overlay.color = Color(0.02, 0.02, 0.05, 0.72)
	_cooldown_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_cooldown_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cooldown_overlay.visible = false
	add_child(_cooldown_overlay)

	_cooldown_label = Label.new()
	_cooldown_label.name = "Cooldown"
	_cooldown_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_cooldown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cooldown_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_cooldown_label.add_theme_font_size_override("font_size", 14)
	_cooldown_label.add_theme_color_override("font_color", Color.WHITE)
	_cooldown_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_cooldown_label.add_theme_constant_override("outline_size", 4)
	_cooldown_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cooldown_label.visible = false
	add_child(_cooldown_label)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	_refresh_background()


func set_hotkey(index: int) -> void:
	_hotkey = index
	_hotkey_label.text = str(index)


func set_skill(skill: SkillDefinition) -> void:
	_skill = skill
	_refresh_content()


func get_skill() -> SkillDefinition:
	return _skill


func set_armed(armed: bool) -> void:
	_armed = armed
	_refresh_background()


func refresh(being: Being) -> void:
	if _skill == null:
		_cooldown_overlay.visible = false
		_cooldown_label.visible = false
		modulate = Color(1, 1, 1, 0.35)
		tooltip_text = ""
		return

	var remaining := being.skills.get_cooldown(_skill)
	var on_cooldown := remaining > 0
	var no_ap := being.turn.action_points < _skill.action_cost
	var disabled := not _skill.enable or on_cooldown or no_ap

	_cooldown_overlay.visible = on_cooldown
	_cooldown_label.visible = on_cooldown
	_cooldown_label.text = str(remaining) if on_cooldown else ""
	modulate = Color(1, 1, 1, 0.45) if disabled and not _armed else Color.WHITE
	tooltip_text = _build_tooltip(remaining)


func activate() -> void:
	if _skill == null:
		return
	skill_pressed.emit(_skill)


func _refresh_content() -> void:
	if _skill == null:
		_icon.texture = null
		_cost_label.text = ""
		tooltip_text = ""
		return

	_icon.texture = _skill.icon
	_cost_label.text = str(_skill.action_cost)
	tooltip_text = _build_tooltip(0)


func _build_tooltip(remaining: int) -> String:
	if _skill == null:
		return ""

	var lines: PackedStringArray = [
		_skill.display_name,
		"AP: %d" % _skill.action_cost,
		"Cooldown: %d" % _skill.cooldown,
	]
	if remaining > 0:
		lines.append("Restante: %d" % remaining)
	if not _skill.description.is_empty():
		lines.append(_skill.description)
	return "\n".join(lines)


func _refresh_background() -> void:
	var bg := get_node_or_null("Background") as ColorRect
	if bg == null:
		return
	bg.color = Color(0.32, 0.22, 0.08) if _armed else Color(0.12, 0.12, 0.15)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			activate()


func _on_mouse_entered() -> void:
	if _armed:
		return
	var bg := get_node_or_null("Background") as ColorRect
	if bg != null:
		bg.color = Color(0.22, 0.22, 0.28)


func _on_mouse_exited() -> void:
	_refresh_background()
