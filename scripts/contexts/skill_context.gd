class_name SkillContext
extends CombatContext

var caster: Being
var skill: SkillInstance
var executions: Dictionary[String, SkillExecution] = {}
