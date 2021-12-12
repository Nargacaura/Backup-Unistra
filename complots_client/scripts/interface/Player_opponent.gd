extends Node

signal target_selected(id)

var card_text = {
	Card.CARD_TYPE.HIDDEN : preload("res://resources/Cards/Back_small.png"),
	Card.CARD_TYPE.DUKE : preload("res://resources/Cards/Duchess1_small.png"),
	Card.CARD_TYPE.ASSASSIN :preload("res://resources/Cards/Assassin1_small.png"),
	Card.CARD_TYPE.CONTESSA : preload("res://resources/Cards/Comtessa1_small.png"),
	Card.CARD_TYPE.CAPTAIN : preload("res://resources/Cards/Captain1_small.png"),
	Card.CARD_TYPE.AMBASSADOR : preload("res://resources/Cards/Ambassador1_small.png"),
	Card.CARD_TYPE.INQUISITOR : preload("res://resources/Cards/Inquisitor1_small.png")
}
var card_dead_text = {
	Card.CARD_TYPE.HIDDEN : preload("res://resources/Cards/Back_small_disabled.png"),
	Card.CARD_TYPE.DUKE : preload("res://resources/Cards/Duchess1_small_disabled.png"),
	Card.CARD_TYPE.ASSASSIN : preload("res://resources/Cards/Assassin1_small_disabled.png"),
	Card.CARD_TYPE.CONTESSA : preload("res://resources/Cards/Comtessa1_small_disabled.png"),
	Card.CARD_TYPE.CAPTAIN : preload("res://resources/Cards/Captain1_small_disabled.png"),
	Card.CARD_TYPE.AMBASSADOR : preload("res://resources/Cards/Ambassador1_small_disabled.png"),
	Card.CARD_TYPE.INQUISITOR : preload("res://resources/Cards/Inquisitor1_small_disabled.png")
}
var cards: Array
var count: int
var _id: int
var balance: int
# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0
	balance = 0
	activate_select(false)
	$Data_container/Balance.set_text(str(2))
	
func set_id(id):
	_id = id+1

func connect_buttons(parent):
#	connect("target_selected",parent, "_on_target_selected")
	connect("target_selected",parent, "_on_selected")
	parent.connect("turn_position",self, "_on_turn_position")
func set_username(username):
	$Data_container/Username.set_text(username)

func update_balance(val):
	balance = val
	$Data_container/Balance.set_text(str(balance))

func activate_select(statut: bool):
	$select_container/select_button.set_disabled(not statut)
	$select_container/select_button.set_visible(statut)

func add_card(_card):
	var card = TextureRect.new()
	card.set_texture(card_text[_card.get_type()])
	card.name = "card_"+str(count)
	count += 1
	$Card_container.add_child(card)
	cards.append(card)

func remove_card(card_id):
	$Card_container.remove_child(cards[card_id])
	count -= 1
	cards[card_id].queue_free()
	cards.remove(card_id)

func hide_stat(set):
	$Data_container.set_visible(not set)

func kill_card(id, card, is_alive):
	if card != null:
		cards[id].set_texture(card_dead_text[card])
	else:
		cards[id].set_texture(card_dead_text[Card.CARD_TYPE.HIDDEN])
	if !is_alive:
		$Data_container/Username.add_color_override("font_color", Color(0.2,0.2,0.2,1))
		$Data_container/Dead_icon.show()

func _on_select_button_pressed():
	emit_signal("target_selected", _id)

func _on_turn_position(player_id):
	if player_id == _id:
		$Data_container/Username.add_color_override("font_color", Color(0.5,0.55,0.8,1))
	else:
		$Data_container/Username.add_color_override("font_color", Color(0.8,0.8,0.8,1))
