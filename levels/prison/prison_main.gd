extends Node

# 
# prison main script
# contains all world information throughout the prison
# also parents each room
# 

# export vars
@export var WALL_INSET_X = 200;
@export var WALL_INSET_Y = 266;
var WALL_INSET = Vector2(WALL_INSET_X, WALL_INSET_Y)

var YOU
var ROOM_CELL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	YOU = $Player
	ROOM_CELL = $RoomCell
	
	# getting out of bed is sometimes the hardest part
	ROOM_CELL.wake_up_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
