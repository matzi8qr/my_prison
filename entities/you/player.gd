extends CharacterBody2D

#
# player main script
# tay worms
# 

# get export variables
@export var speed = 100

# global game vars
var parent
var is_in_prison = false
var screen_size
var input_lock = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	parent = self.find_parent("PrisonMain")
	is_in_prison = parent != null
	
	$AnimatedSprite2D.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !input_lock:
		# player movement
		var velocity = _get_walk_input()
		_move_player(delta, velocity)
		
		# interact input - interactable is the object clicked on, emit signal with name for obj to recieve
		if Input.is_action_just_pressed("interact"):
			process_interaction()
			


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
	velocity = direction * speed
	move_and_slide()
	
	# check and clamp to prison walls
	var wall_inset = Vector2.ZERO
	if is_in_prison:
		wall_inset = parent.WALL_INSET
	position.x = clamp(position.x, wall_inset.x, screen_size.x - wall_inset.x)	
	position.y = clamp(position.y, wall_inset.y, screen_size.y - wall_inset.y*.7)
	
	# choose anim
	var anim = "idle"
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		anim = "walk"
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		anim = "walk"
	$AnimatedSprite2D.animation = anim


func process_interaction() -> void:
	
	var interactables = $PlayerInteractionBox.get_overlapping_bodies()
	if !interactables.is_empty():
		input_lock = true
		$AnimatedSprite2D.animation = "idle"
		var interaction = interactables[0].interact 
		var text_queue = interaction.call()
		parent.TEXT_MANAGER.add_each_text(text_queue)


func _on_room_cell_youre_awake() -> void:
	visible = true
	input_lock = false


func _on_lock_player_input() -> void:
	input_lock = true

func _on_unlock_player_input() -> void:
	input_lock = false
