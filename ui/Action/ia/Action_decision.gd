class_name ActionDecision
extends RefCounted

enum Type {
	#NONE,
	MOVE,
	ATTACK,
	#SKILL,
	WAIT
}

var type : Type
var target : Being
var tile : Vector2i
var grid : GridSystem
