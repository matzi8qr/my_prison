extends Node2D

# finally,,,
signal youre_awake

var wake_up_anim_table = ["default", "sleep", "get_up_sleep", "sit", "get_up_sit"]
var anim_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# set animation value for da bed
	$Bed/AnimatedSprite2D.animation = wake_up_anim_table[anim_index]
	
	
func wake_up_player() -> void:
	anim_index = 1
	$Bed/AnimatedSprite2D.play()
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_index == wake_up_anim_table.find("get_up_sit"):
		youre_awake.emit()
		anim_index = 0
		$Bed/AnimatedSprite2D.play()
	else:
		anim_index += 1
		$Bed/AnimatedSprite2D.play()
