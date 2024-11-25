extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Important for phone screens with timebar
func set_time_label(time: String) -> void:
	$TimeBar/TimeLabel.text = time


func _on_quit_button_pressed() -> void:
	get_tree().quit()
