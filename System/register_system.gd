class_name RegisterSystem
extends Node2D

var labels: Array[Label] = []
@onready var register_service: RegisterService
@onready var container: VBoxContainer

func _init(register_service: RegisterService) -> void:
	self.register_service = register_service
	container = VBoxContainer.new()
	add_child(container)

func _ready() -> void:
	for i in range(5):
		var lbl := Label.new()
		lbl.text = ""
		container.add_child(lbl)
		labels.append(lbl)
	
	# Registrar algunos eventos de ejemplo
	register_service.register_event("Jugador inició partida")
	register_service.register_event("Encontró un cofre")
	register_service.register_event("Recibió daño")
	register_service.register_event("Usó poción")
	register_service.register_event("Subió de nivel")
	
	update_logs()

func update_logs() -> void:
	var last_events := register_service.get_last_events(5)

	for i in range(labels.size()):
		labels[i].text = last_events[i] if i < last_events.size() else ""
