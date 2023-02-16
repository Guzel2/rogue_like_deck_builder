extends TouchScreenButton

onready var parent = get_parent().get_parent()

var card_name = 'test'

var size = normal.get_size()

var just_pressed = false

var start_pos
var desired_pos
var action_on_desired_pos = null

var top_area_y = 150
var play_area_y = 210

func _ready():
	start_pos = position
	desired_pos = start_pos

func _process(delta):
	if is_pressed():
		position = get_global_mouse_position() - size/2
		just_pressed = true
		print(card_name)
	elif just_pressed:
		just_pressed = false
		
		var y_pos = position.y + size.y/2
		
		if y_pos < top_area_y:
			return_to_hand()
		elif y_pos < play_area_y:
			action_on_desired_pos = null
			desired_pos = position
			parent.play_card(card_name, self)
		else:
			return_to_hand()
	
	elif desired_pos != position:
		var dir = (desired_pos - position)
		if dir.length() > 1:
			position += dir/10 * (delta * 60)
		else:
			position = desired_pos
			
			match action_on_desired_pos:
				null:
					pass
				'remove':
					queue_free()

func discard_this():
	parent.discard.append(card_name)
	desired_pos = Vector2(125, 230) - size/2
	action_on_desired_pos = 'remove'

func return_to_hand():
	action_on_desired_pos = null
	desired_pos = start_pos
	
