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
	if game_root.visible && game_root.phone_visible:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("phone"), false)
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
	if game_root:
		if game_root.phone_visible && game_root.visible:
			try_play_song()
		else:
			paused = true
			pause.emit()
			AudioServer.set_bus_mute(AudioServer.get_bus_index("phone"), true)
			position = Vector2.ZERO

 
func _on_you_lose() -> void:
	position = Vector2.ZERO
	paused = true
	try_play_song()
	# game over and restart
	
func try_play_song() -> void:
	var player = $MusicPlayer
	if not player.playing && not AudioServer.is_bus_mute(1):
		$MusicPlayer.play()
