class_name AttackContext
extends CombatContext

var attacker : CombatParticipant
var target : CombatParticipant

var flags : Array[StringName]
var tags := {
	"precision":0,
	"armor_penetration":0,
}

var stats:AttackStats = AttackStats.new()
var result:AttackResult = AttackResult.new()
