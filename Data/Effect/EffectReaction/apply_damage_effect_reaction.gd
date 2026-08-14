class_name ApplyDamageEffectReaction
extends TurnEndEffectReaction

var damage: int = 0

func execute(context: EffectContext) -> void:
	HealthSystem.apply_damage(
		context.entity.health,
		damage
	)
