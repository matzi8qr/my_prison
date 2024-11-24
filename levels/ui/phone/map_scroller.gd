extends Node2D

@export var BASE_VELOCITY = -4.5
@export var velocity = BASE_VELOCITY

@onready var game_root = find_parent("PhoneCat")

signal pause
signal unpause
var paused=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paused = true
	position = Vector2.ZERO
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_root.visible:
		if paused:
			if Input.is_action_just_pressed("interact"):
				paused = false
				unpause.emit()
		elif not paused:
			position.x += velocity
			# TODO attempt reposition and generate next chunk
			

func spawn_shuriken() -> void:
	var rand_y = randi_range(64, get_viewport_rect().size.y - 64)
	# todo spawn shurikens randomly


func _on_ninja_cat_dash() -> void:
	velocity = BASE_VELOCITY * 0.1
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", _reset_velocity)
	tween.tween_property(self, "velocity", BASE_VELOCITY*2, 0.7)


func _reset_velocity() -> void:
	velocity = BASE_VELOCITY


func _on_phone_cat_visibility_changed() -> void:
	# when tab switched or phone closed
	paused = true
	pause.emit()
	_on_you_lose()

 
func _on_you_lose() -> void:
	print("you_lose")
	position = Vector2.ZERO
	paused = true
	# game over and restart
