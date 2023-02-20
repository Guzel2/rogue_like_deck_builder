extends TouchScreenButton

onready var parent = get_parent()
onready var sprite = find_node('sprite')

var card_name = 'test'

var just_pressed = false
var is_pressed = false

var locked = false

var start_pos
var desired_pos
var action_on_desired_pos = null

var top_area_y = 150
var play_area_y = 210

func _ready():
	start_pos = position
	desired_pos = start_pos
	
	sprite.animation = card_name

func _process(delta):
	is_pressed = false
	if is_pressed() \
	and !locked \
	and action_on_desired_pos != 'remove':
		is_pressed = true
	
	if is_pressed:
		position = get_global_mouse_position()
		for child in parent.get_children():
			if child != self:
				child.lock()
		for child in parent.parent.hand_cards.get_children():
			child.lock()
		
		just_pressed = true
	elif just_pressed:
		just_pressed = false
		
		for child in parent.get_children():
			if child != self:
				child.unlock()
		for child in parent.parent.hand_cards.get_children():
			child.unlock()
		
		var y_pos = position.y
		
		if y_pos < top_area_y:
			return_to_center_row()
		elif y_pos < play_area_y:
			action_on_desired_pos = null
			desired_pos = position
			parent.parent.buy_card(card_name, self)
		else:
			return_to_center_row()
	
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

func discard_this(new_pos: Vector2):
	parent.parent.discard.append(card_name)
	desired_pos = new_pos
	action_on_desired_pos = 'remove'

func return_to_center_row():
	action_on_desired_pos = null
	desired_pos = start_pos

func lock():
	locked = true

func unlock():
	locked = false
