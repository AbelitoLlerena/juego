class_name EffectContext
extends RefCounted

# Entidad que lanza el efecto
var source : Node

# Entidad que tiene el efecto
var owner : Node

# Entidad afectada por la acción
var target : Node

# Instancia concreta del efecto
var effect : EffectInstance

var event
