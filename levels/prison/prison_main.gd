extends Node

# 
# prison main script
# contains all world information throughout the prison
# also parents each room
# 

# export vars
@export var WALL_INSET_X = 200;
@export var WALL_INSET_Y = 200;
var WALL_INSET = Vector2(WALL_INSET_X, WALL_INSET_Y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
