extends CharacterBody2D

@export var speed := 150.0

var path: Array[Vector2] = []
var target_position: Vector2

func _physics_process(delta):

	if path.is_empty():
		velocity = Vector2.ZERO
		return

	target_position = path[0]

	var direction = target_position - global_position

	if direction.length() < 2:

		global_position = target_position
		path.pop_front()

	else:

		velocity = direction.normalized() * speed
		move_and_slide()
