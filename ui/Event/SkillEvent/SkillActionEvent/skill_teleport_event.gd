class_name SkillTeleportEvent
extends SkillActionEvent

var destination: Vector2i

var context: SkillEvaluationContext
var system: MovementSystem

func execute() -> void:
	_analice_context()
	system.teleport_event(caster, destination)

func _analice_context():
	caster = context.caster
	destination = context.tile
