extends CanvasLayer

var screen_size
var root: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root = find_parent("PrisonMain")
	screen_size = get_viewport().get_visible_rect().size
	
	# transform wall layer to center
	var center_screen = screen_size / 2
	transform = Transform2D(0, center_screen)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
