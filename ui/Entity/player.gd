class_name Player
extends Being

var combating: bool = false

func initialice() -> void:
	entity_name = "Paco"
	turn.max_action_points = 3
	turn.action_points = 3

	var blink := BlinkExplosion.new()
	skills.skills.append(blink)
