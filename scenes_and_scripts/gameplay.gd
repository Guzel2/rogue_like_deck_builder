extends Node2D

onready var hand_cards = find_node('hand')
onready var center_cards = find_node('center_row')
onready var money_display = find_node('money_display')

var deck = ['basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_attack', 'basic_attack', 'basic_attack']
var hand = []
var discard = []

var money = 0

var due_actions = []
var current_action = null

var action_on_next_card = 'play'

func _ready():
	deck.shuffle()
	draw_cards(5)

func _process(_delta):
	if current_action == null:
		if !due_actions.empty():
			current_action = due_actions.pop_front()
	else:
		match current_action[0]:
			'money':
				money += current_action[1]
				current_action = null
				update()
			'draw':
				draw_cards(current_action[1])
				current_action = null
			'bleeding':
				pass
			'hit':
				pass
			'strength':
				pass
			'banish_from_hand':
				if action_on_next_card == 'play':
					action_on_next_card = 'banish'
					current_action = null
			'banish_from_discard':
				pass
			'banish_from_center':
				pass
			'discard_from_hand':
				if action_on_next_card == 'play':
					action_on_next_card = 'discard'
					current_action = null
			'return_from_discard':
				pass

func play_card(card_name: String, card):
	var played = true
	
	match card_name: #check for conditions, for example if you need to discard cards
		'0':
			pass
		'1':
			played = false
	
	if played:
		while true:
			var hand_card = hand.pop_front()
			
			if hand_card == card_name:
				break
			
			hand.append(hand_card)
		
		print(action_on_next_card)
		
		match action_on_next_card:
			'play':
				match card_name:
					'basic_money':
						due_actions.append(['money', 1])
					
					'basic_attack':
						due_actions.append(['draw', 2])
						due_actions.append(['discard_from_hand', 1])
				card.discard_this()
			'discard':
				card.discard_this()
				action_on_next_card = 'play'
			'banish':
				card.banish_this()
				action_on_next_card = 'play'
		
		hand_cards.organize_cards()
		
	else:
		card.return_to_hand()

func buy_card(card_name: String, card):
	var bought = true
	
	match card_name: #check for conditions, for example if you need to discard cards
		'0':
			pass
		'1':
			bought = false
		'basic_attack':
			if money > 0:
				money -= 1
			else:
				bought = false
	
	if bought:
		card.discard_this(Vector2(125, 230))
		center_cards.organize_cards()
		
		discard.append(card_name)
		
		update()
	else:
		card.return_to_center_row()

func update():
	money_display.text = String(money)

func start_turn():
	pass

func end_turn():
	for card in hand_cards.get_children():
		card.discard_this()
	draw_cards(5)
	
	money = 0
	update()

func draw_cards(num_of_cards):
	var x = 0
	
	while x < num_of_cards:
		if !deck.empty():
			var new_card = deck.pop_front()
			hand.append(new_card)
			add_card_to_hand(new_card)
			
			x += 1
		
		else:
			print(discard)
			discard.shuffle()
			deck = discard.duplicate()
			discard.clear()

func add_card_to_hand(card_name):
	var card = load("res://scenes_and_scripts/gameplay/hand_card.tscn").instance()
	card.card_name = card_name
	card.position.y = 250
	hand_cards.add_child(card)
	hand_cards.organize_cards()

func _on_end_turn_released():
	end_turn()
