extends Area2D

#
# player main script
# tay worms
# 

# get export variables
@export var speed = 100

# global game vars
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = _get_walk_input()
	_move_player(delta, velocity)
	



func _get_walk_input() -> Vector2:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 0.6
	if Input.is_action_pressed("move_down"):
		velocity.y += 0.6
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized()
	
	return velocity
	

func _move_player(delta: float, direction: Vector2) -> void:
	var velocity = direction * (delta * speed)
	position += velocity
	position.clamp(Vector2.ZERO, screen_size)
