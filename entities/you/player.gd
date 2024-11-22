extends Area2D

#
# player main script
# tay worms
# 

# signal
signal hit

# get export variables
@export var speed = 100

# global game vars
var parent
var is_in_prison = false
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	parent = self.find_parent("PrisonMain")
	is_in_prison = parent != null
	
	$AnimatedSprite2D.play()
	

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
	
	# check and clamp to prison walls
	var wall_inset = Vector2.ZERO
	if is_in_prison:
		wall_inset = parent.WALL_INSET
		print(wall_inset)
	position.x = clamp(position.x, wall_inset.x, screen_size.x - wall_inset.x)	
	position.y = clamp(position.y, wall_inset.y, screen_size.y - wall_inset.y)
	
	# choose anim
	var anim = "idle"
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		anim = "walk"
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		anim = "walk"
	$AnimatedSprite2D.animation = anim


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
