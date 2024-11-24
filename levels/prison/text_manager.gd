extends CanvasLayer

#
# this script manages the text box
#

var CHAR_READ_RATE = 0.02

@onready var root = get_parent()

@onready var textbox = $Textbox
@onready var text_label = $Textbox/TextSubContainer/RichTextLabel
enum Textbox_State {READY, READING_SKIPPABLE, READING_UNSKIP, FINISHED}
var cur_state = Textbox_State.READY

var tween
var text_queue = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match cur_state:
		Textbox_State.READY:
			if !text_queue.is_empty():
				read_next_text()
		Textbox_State.READING_SKIPPABLE:
			if Input.is_action_just_pressed("interact") || Input.is_action_just_pressed("ui_accept"):
				text_label.visible_ratio = 1
				tween.stop()
				cur_state = Textbox_State.FINISHED
		Textbox_State.FINISHED:
			if Input.is_action_just_pressed("interact") || Input.is_action_just_pressed("ui_accept"):
				if !text_queue.is_empty():
					read_next_text()
				else:
					hide_textbox()
	

func hide_textbox() -> void:
	text_label.text = ""
	text_label.visible_ratio = 0
	tween.stop()
	textbox.visible = false
	cur_state = Textbox_State.READY
	root.unlock_player_input.emit()
	

func show_textbox() -> void:
	textbox.visible = true
	root.lock_player_input.emit()
	

func add_text(text: String) -> void:
	text_queue.append("[color=AFAF9E]" + text + "[/color]")
	

func add_each_text(texts: Array) -> void:
	for text in texts:
		add_text(text)
			
	
func read_next_text(skippable = true) -> void:
	if skippable:
		cur_state = Textbox_State.READING_SKIPPABLE
	else:
		cur_state = Textbox_State.READING_UNSKIP
		
	var next_text = text_queue.pop_front()
	text_label.push_color(Color("#AFAF9E"))
	text_label.visible_ratio = 0
	text_label.text = next_text
	
	if tween:
		tween.kill()	
	tween = get_tree().create_tween()
	tween.connect("finished", _on_tween_finished)
	tween.tween_property(text_label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)
	tween.play()
	
	show_textbox()
	
	
func _on_tween_finished() -> void:
	cur_state = Textbox_State.FINISHED
	tween.stop()
	
