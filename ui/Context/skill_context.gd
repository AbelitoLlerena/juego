class_name SkillContext
extends CombatContext

var caster: Being
var skill: SkillDefinition
var executions: Dictionary[String,SkillExecution]
var flags := {}
