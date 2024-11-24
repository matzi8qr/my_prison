extends StaticBody2D

@export var action_name = "interact"

var interact: Callable

func _ready() -> void:
	interact = Callable(self, "no_func")

func no_func() -> Array:
	
	return []
