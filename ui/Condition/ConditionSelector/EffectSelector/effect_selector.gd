class_name EffectSelector
extends ConditionSelector

func select(context) -> Variant:
	return get_effect(context)

func get_effect(context) -> EffectDefinition:
	return null

#CurrentEffectSelector
#SourceEffectSelector
