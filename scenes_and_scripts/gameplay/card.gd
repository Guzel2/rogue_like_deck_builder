extends TouchScreenButton

onready var parent = get_parent()

var card_name = 'test'

var size = normal.get_size()

var just_pressed = false

var start_pos
var desired_pos

var top_area_y = 150
var play_area_y = 210

func _ready():
	start_pos = position
	desired_pos = start_pos

func _process(delta):
	if is_pressed():
		position = get_global_mouse_position() - size/2
		just_pressed = true
	elif just_pressed:
		just_pressed = false
		
		var y_pos = position.y + size.y/2
		
		if y_pos < top_area_y:
			desired_pos = start_pos
		elif y_pos < play_area_y:
			desired_pos = position
			parent.play_card(card_name)
		else:
			desired_pos = start_pos
	
	elif desired_pos != position:
		var dir = (desired_pos - position)
		if dir.length() > 1:
			position += dir/10 * (delta * 60)
		else:
			position = desired_pos
