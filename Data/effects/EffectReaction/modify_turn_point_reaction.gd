class_name ModifyTurnPointsEffectReaction
extends TurnStartEffectReaction

var amount: int = 0

func execute(context: EffectContext) -> void:
	context.entity.turn.movement_points += amount
