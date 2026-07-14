class_name Player
extends Node2D

var grid_position : Vector2i = Vector2i.ZERO
var alert: bool = false
var facing_direction: Vector2i = Vector2i.DOWN
@onready var animSprite = $AnimatedSprite2D

func _ready() -> void:
	animSprite.play("idle_down")


func play_walk(direction: Vector2i) -> void:
	if direction == Vector2i.ZERO:
		return
	facing_direction = direction
	match direction:
		Vector2i.UP:
			animSprite.play("up")
		Vector2i.DOWN:
			animSprite.play("down")
		Vector2i.LEFT:
			animSprite.play("left")
		Vector2i.RIGHT:
			animSprite.play("right")


func idle() -> void:
	match facing_direction:
		Vector2i.UP:
			animSprite.play("idle_up")
		Vector2i.DOWN:
			animSprite.play("idle_down")
		Vector2i.LEFT:
			animSprite.play("idle_left")
		Vector2i.RIGHT:
			animSprite.play("idle_right")
