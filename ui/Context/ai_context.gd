class_name AIContext
extends RefCounted

var actor: CombatParticipant

# Memoria persistente
var state: AIState

# Información del turno
var turn: int

# Visibilidad
var visible_allies: Array[CombatParticipant] = []
var visible_enemies: Array[CombatParticipant] = []
var visible_neutrals: Array[CombatParticipant] = []

# Posiciones
var actor_tile: Vector2i

# Movimiento
var reachable_tiles: Array[Vector2i] = []

# Habilidades utilizables
var usable_skills: Array[SkillDefinition] = []

# Acciones generadas
var actions: Array[ActionDecision] = []
