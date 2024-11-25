extends Node

# 
# prison main script
# contains all world information throughout the prison
# also parents each room
# 

signal lock_player_input
signal unlock_player_input

# important globals
@onready var YOU = $Player
@onready var ROOM_CELL = $RoomCell
@onready var TEXT_MANAGER = $TextManager

# flag table?
var FLAG_TABLE = {"has_phone": false, "phone_open": false}

# smokywall vars
@export var WALL_INSET_X = 200;
@export var WALL_INSET_Y = 275;
var WALL_INSET = Vector2(WALL_INSET_X, WALL_INSET_Y)
var wall_intensity = 1

# timer vars
var today = 0  # day counter, useed throughout
var timer_stopwatch = 0  # count up is easier tbh
var time_stop = true
var time_speed = 10  # tasks like gaming make time go faster
var last_speed = 10

var starting_min = randi_range(0, 60)
var starting_hour = 9 + (today)**2 + randi_range(-1, 2)

# Called when the node enters the scene tree for the first time.
# should be happening on day start
func _ready() -> void:	
	# getting out of bed is sometimes the hardest part
	ROOM_CELL.wake_up_player()
	
	# start timer
	timer_stopwatch = 0;
	time_stop = false;
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_increment_timer(delta)
	
	# check for phone input and toggle phone on off
	if Input.is_action_just_pressed("open_phone") && FLAG_TABLE["has_phone"]:
		if FLAG_TABLE["phone_open"]:
			close_phone()
		else:
			open_phone()
	
	
func open_phone() -> void:
	FLAG_TABLE["phone_open"] = true
	time_speed *= 1.5
	$Player/AnimatedSprite2D.animation = "idle"  # upgrade to phone-idle soon!
	lock_player_input.emit()
	$Phone.visible = true
	
	
func close_phone() -> void:
	FLAG_TABLE["phone_open"] = false
	time_speed *= 0.67
	unlock_player_input.emit()
	$Phone.visible = false;
	

func _increment_timer(delta: float) -> void:
	if time_stop:
		return
		
	timer_stopwatch += (delta * time_speed)
	$tempTimerText.text = timer_to_clock() + "\nSpeed: " + str(time_speed)
	

func timer_to_clock(getHourOnly = false) -> String:
	var sec = int(timer_stopwatch)  # truncate ms
	var min = starting_min + sec/(13 - today**2)  # hardcode unusual second/min, gets faster each day
	var hour = starting_hour + int(min / 60)
	min %= 60
	
	# TODO random and weird stuff, hour skips.. changes to starting min/hour.
	# do not modify timer_stopwatch for this effect
	
	if getHourOnly:
		return str(hour)
	
	return "%02d:%02d" % [hour, min]
	

func set_prison_world_environment() -> void:
	var env = $WorldEnvironment.environment
	env.glow_hdr_threshold = 0.5
	env.adjustment_brightness = 0.69
	env.adjustment_contrast = 1.15
	env.adjustment_saturation = 1.57


func set_interrogation_world_environment() -> void:
	var env = $WorldEnvironment.environment
	env.glow_hdr_threshold = 0.36
	env.adjustment_brightness = 0.69
	env.adjustment_contrast = 1.3
	env.adjustment_saturation = 3.2


func _on_phone_pause_time(code: String) -> void:
	if code == "pause":
		last_speed = time_speed
		time_speed = 0
	else:
		time_speed = last_speed
