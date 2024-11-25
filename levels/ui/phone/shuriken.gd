#extends RigidBody2D
extends Area2D


var flying = true

@onready var scroller = find_parent("MapScroller")

@export var velocity_x = -400

signal you_lose
signal deflect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#gravity_scale = 0
	#linear_velocity = Vector2(velocity_x, 0)
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if flying:
		you_lose.emit()


func _on_area_entered(area: Area2D) -> void:
	flying = false
	#linear_velocity /= 2
	$CollisionShape2D.disabled = true
	#gravity_scale = 1
	$AnimatedSprite2D.speed_scale = 0.66
	#apply_impulse(Vector2(randf(), randf()).normalized())
