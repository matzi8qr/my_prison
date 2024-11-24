extends StaticBody2D

@export var action_name = "interact"

var interact: Callable

func _ready() -> void:
	interact = Callable(self, "not_tired")

func not_tired() -> Array:
	
	return ["Not tired enough..."]
