extends Area2D

#
# mirror script
# handles showing who looks back from the mirror
# among other mirror events

# signals
signal enter_mirror

# instance vars
var root
var is_in_prison = false
var you: CharacterBody2D
var your_mirror: AnimatedSprite2D
var mirror_box: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root = self.find_parent("PrisonMain")
	is_in_prison = root != null
	
	mirror_box = $MirrorBoxArea2D
	your_mirror = $MirrorMaskSprite/MirrorPlayerSprite
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if you && your_mirror.visible :
		# subtract translation offset of mirror areas
		your_mirror.global_position = you.global_position - Vector2(-48, 48)
		your_mirror.animation = you.get_node("AnimatedSprite2D").animation
		your_mirror.frame = you.get_node("AnimatedSprite2D").frame
		your_mirror.flip_h = you.get_node("AnimatedSprite2D").flip_h


# called on PLayerInteractionBox entering MirrorView - layer2
func _on_area_entered(body: Node2D) -> void:
	if body.name == "PlayerInteractionBox":
		enter_mirror.emit()
		your_mirror.visible = true
		if !you:
			you = body.find_parent("Player")

# called on player exiting MirrorView - layer2
func _on_area_exited(body: Node2D) -> void:
	if body.name == "PlayerInteractionBox":
		your_mirror.visible = false;
