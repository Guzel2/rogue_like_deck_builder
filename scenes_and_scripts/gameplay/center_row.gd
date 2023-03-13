extends Node2D

onready var parent = get_parent()

var cards = ['basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_attack', 'basic_attack', 'basic_attack', 'basic_attack', 'basic_attack', 'basic_attack', 'basic_attack', ]

var x_offset = 30
var y_offset = 130

func _ready():
	randomize()
	cards.shuffle()
	organize_cards()

func organize_cards():
	var cards = []
	
	var x = 0
	
	while true:
		cards.clear()
		var children = get_children()
		
		for child in children:
			if child.action_on_desired_pos != 'remove':
				cards.append(child)
		
		if cards.size() < 5:
			add_card_to_center_row()
		else:
			break
		
		x += 1
		if x > 10:
			break
	
	var step_size = 20 #card width
	
	for card in cards.size():
		cards[card].desired_pos = Vector2(x_offset, y_offset) + Vector2(step_size*card, 0)
		cards[card].start_pos = cards[card].desired_pos
		cards[card].action_on_desired_pos = null

func add_card_to_center_row():
	if !cards.empty():
		var card_name = cards.pop_front()
		var card = load("res://scenes_and_scripts/gameplay/center_card.tscn").instance()
		card.card_name = card_name
		card.position = Vector2(140, 130)
		add_child(card)
		organize_cards()
	else:
		print('no_cards_left_in_center row')
