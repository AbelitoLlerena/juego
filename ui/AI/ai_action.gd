class_name AIAction
extends RefCounted

enum Type
{
	WAIT,
	MOVE,
	ATTACK,
	SKILL,
	INTERACT
}

var type: Type
var destination: Vector2i
var target: Being
var skill: SkillDefinition
var score: float
