extends Node2D

onready var hand_cards = find_node('hand_cards')

var deck = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
var hand = []
var discard = []

func _ready():
	draw_cards(1)

func play_card(card_name: String, card):
	print(card_name)
	
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
		
		match card_name:
			'0':
				print('test effect')
				draw_cards(3)
		
	else:
		card.return_to_hand()

func start_turn():
	pass

func end_turn():
	for card in hand_cards.get_children():
		card.discard_this()
	draw_cards(2)

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
			
			x += 1

func add_card_to_hand(card_name):
	var card = load("res://scenes_and_scripts/gameplay/card.tscn").instance()
	card.card_name = card_name
	hand_cards.add_child(card)
	hand_cards.organize_cards()

func _on_end_turn_released():
	end_turn()
