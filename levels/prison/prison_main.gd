extends Node

# 
# prison main script
# contains all world information throughout the prison
# also parents each room
# 

# important globals
var YOU
var ROOM_CELL

# flag table?

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

var starting_min
var starting_hour

# Called when the node enters the scene tree for the first time.
# should be happening on day start
func _ready() -> void:
	YOU = $Player
	ROOM_CELL = $RoomCell
	
	# getting out of bed is sometimes the hardest part
	ROOM_CELL.wake_up_player()
	
	# seed random start times
	starting_min = randi_range(0, 60)
	starting_hour = 9 + (today)**2 + randi_range(-1, 2)
	# start timer
	timer_stopwatch = 0;
	time_stop = false;
	
	# draw smoky vignette
	# draw_walls()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_increment_timer(delta)
	
	
func draw_walls() -> void:
	# use CanvasItem.queue_redraw()
	# interacts w canvas group
	# include the bars in this
	# use particles and another smoky glow effect?
	$WallCanvasGroup.queue_redraw()
	
	
func _increment_timer(delta: float) -> void:
	if time_stop:
		return
		
	timer_stopwatch += (delta * time_speed)
	$tempTimerText.text = timer_to_clock()
	

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
	
