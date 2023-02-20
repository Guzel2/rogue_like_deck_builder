extends Node2D

onready var hand_cards = find_node('hand')
onready var center_cards = find_node('center_row')
onready var money_display = find_node('money_display')

var deck = ['basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_money', 'basic_attack', 'basic_attack', 'basic_attack']
var hand = []
var discard = []

var money = 0

func _ready():
	deck.shuffle()
	draw_cards(5)

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
		
		card.discard_this()
		hand_cards.organize_cards()
		
		match card_name:
			'basic_money':
				money += 1
			
			'basic_attack':
				pass
		
		update()
		
	else:
		card.return_to_hand()

func buy_card(card_name: String, card):
	var bought = true
	
	match card_name: #check for conditions, for example if you need to discard cards
		'0':
			pass
		'1':
			bought = false
	
	if bought:
		print('sussy')
		card.discard_this(Vector2(125, 230))
		center_cards.organize_cards()
		
		discard.append(card_name)
		
		update()
	else:
		card.return_to_hand()

func update():
	money_display.text = String(money)

func start_turn():
	pass

func end_turn():
	for card in hand_cards.get_children():
		card.discard_this()
	draw_cards(5)
	
	money = 0

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
