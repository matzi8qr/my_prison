extends StaticBody2D

@export var action_name = "interact"

@onready var root = find_parent("PrisonMain")

var interact: Callable

func _ready() -> void:
	interact = Callable(self, "get_phone")

func get_phone() -> Array:
	root.FLAG_TABLE["has_phone"] = true
	# open phone after? with notify
	return ["[color=6f6f65]You acquired [b]Phone[/b][/color]", "[color=6f6f65]You'll keep it somewhere [wave amp=20]convenient[/wave]"]
