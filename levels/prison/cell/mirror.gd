extends Area2D

#
# mirror script
# handles showing who looks back from the mirror
# among other mirror events

# signals
signal enter_mirror

# instance vars
var mirror_box: Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mirror_box = $MirrorBoxArea2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
