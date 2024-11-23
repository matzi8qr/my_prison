extends Node2D

#
# this script controls the eye lights

@export var blink_frequency = 333

var blink_chance_increment = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# passive state blink chancce
	blink_chance_increment += randf()
	if blink_chance_increment > blink_frequency:
		blink_chance_increment = 0
		if randi_range(0, 1):
			$AnimationPlayer.play("passive_blink")
		else:
			$AnimationPlayer.play("passive_shifty")
		
		

func eye_closed() -> void:
	$PointLight2D.enabled = false


func eye_open() -> void:
	$PointLight2D.enabled = true
