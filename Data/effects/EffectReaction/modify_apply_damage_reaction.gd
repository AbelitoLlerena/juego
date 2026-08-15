class_name ModifyApplyDamageEffectReaction
extends StackGainEffectReaction

var amount: int = 0

func execute(context: EffectContext) -> void:
	var reaction := context.effect.reactions[EffectTrigger.Trigger.TURN_END]
	reaction.damage += amount
