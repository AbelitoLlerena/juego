class_name Thing
extends Entity

@export var blocks_vision: bool = false
@export var openable: OpenableComponent = null
@export var attackable: AttackableComponent = null

#posteriormente a los hijos se les puede 
#agregar cosas como:
#VisionBlocker
#Openable(cofres, puertas)
