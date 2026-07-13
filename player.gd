class_name Player
extends AnimatedSprite2D

var grid_position: Vector2i = Vector2i.ZERO
var alert: bool = false
var facing_direction: Vector2i = Vector2i.DOWN


func _ready() -> void:
	play("idle_down")


func play_walk(direction: Vector2i) -> void:
	if direction == Vector2i.ZERO:
		return
	facing_direction = direction
	match direction:
		Vector2i.UP:
			play("up")
		Vector2i.DOWN:
			play("down")
		Vector2i.LEFT:
			play("left")
		Vector2i.RIGHT:
			play("right")


func idle() -> void:
	match facing_direction:
		Vector2i.UP:
			play("idle_up")
		Vector2i.DOWN:
			play("idle_down")
		Vector2i.LEFT:
			play("idle_left")
		Vector2i.RIGHT:
			play("idle_right")
