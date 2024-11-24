extends AspectRatioContainer

#
# phone script
@onready var root = find_parent("PrisonMain")

enum Display {HOME, TEXTS, CAT, PAUSE}
@onready var display_keys = {Display.HOME: $ScreenMargins/VBoxContainer/SubViewportContainer/PhoneViewport/PhoneHome,
					Display.TEXTS: $ScreenMargins/VBoxContainer/SubViewportContainer/PhoneViewport/PhoneTexts,
					Display.CAT: $ScreenMargins/VBoxContainer/SubViewportContainer/PhoneViewport/PhoneCat,
					Display.PAUSE: $ScreenMargins/VBoxContainer/SubViewportContainer/PhoneViewport/PhonePause}

var cur_display = Display.HOME
@onready var cur_screen = display_keys[Display.HOME]

var unpaused_time_speed
var timer_blink_counter = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# link taskbar buttons to methods
	var taskbar = $ScreenMargins/VBoxContainer/Panel/MarginContainer/TaskbarContainer
	taskbar.get_node("ButtonMessages").pressed.connect(self._button_messages)
	taskbar.get_node("ButtonNinjacat").pressed.connect(self._button_ninjacat)
	taskbar.get_node("ButtonSettings").pressed.connect(self._button_settings)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cur_screen
	
	# ninjacat blocks time bar
	if cur_display != Display.CAT:
		var time = get_time_label(cur_display == Display.PAUSE)
		cur_screen.set_time_label(time)
	
func get_time_label(paused = false) -> String:
	var time: String
	if root:
		time = root.timer_to_clock()
	else:
		time = "11:11"
	if !paused:
		timer_blink_counter += 1
		timer_blink_counter %= 8
	if timer_blink_counter > 3:
		time.replace(":", " ")
		
	return "[color=DBB614]" + time + "[/color]"

func _button_messages() -> void:
	print("message")
	

func _button_ninjacat() -> void:
	cur_screen.visible = false
	cur_display = Display.CAT
	cur_screen = display_keys[cur_display]
	cur_screen.visible = true
	

func _button_settings() -> void:
	print("pause")
