extends CanvasLayer

#
# this script manages the text box
#

@export var CHAR_READ_RATE = 0.05

@onready var textbox = $Textbox
@onready var text_label = $Textbox/TextSubContainer/RichTextLabel
enum Textbox_State {READY, READING, FINISHED}
var cur_state = Textbox_State.READY

@onready var tween = get_tree().create_tween()
var text_queue = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect listener to dialoge reader finish
	tween.connect("finished", _on_tween_finished)
	
	# push better color into textbox
	text_label.push_color(Color("#AFAF9E"))
	
	# textbox debug
	add_text("dabadeedabadoo")
	add_text("I am a hoot!")
	read_next_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match cur_state:
		Textbox_State.READY:
			pass
		Textbox_State.READING:
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
	textbox.visible = false
	cur_state = Textbox_State.READY
	

func show_textbox() -> void:
	# while textqueue not empty.. fill text and listen for input
	textbox.visible = true
	

func add_text(text: String) -> void:
	text_queue.append(text)
	
	
func read_next_text() -> void:
	cur_state = Textbox_State.READING
	var next_text = text_queue.pop_front()
	text_label.visible_ratio = 0
	text_label.text = next_text
	tween.tween_property(text_label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)
	show_textbox()
	tween.play()
	
func _on_tween_finished() -> void:
	cur_state = Textbox_State.FINISHED
	tween.stop()
	
