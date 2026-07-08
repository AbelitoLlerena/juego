extends CharacterBody2D

@export var speed := 150.0

var target_position: Vector2
var moving := false

func _ready():
	target_position = global_position

func _physics_process(delta):

	if moving:

		var direction = target_position - global_position

		if direction.length() < 2:
			global_position = target_position
			velocity = Vector2.ZERO
			moving = false
		else:
			velocity = direction.normalized() * speed
			move_and_slide()
