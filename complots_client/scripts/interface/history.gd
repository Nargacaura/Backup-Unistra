extends Node
############################# HISTORY ##########################################

########################### Nodes acquired #####################################
onready var counterer = $counterer_grid/counterer
onready var counterer_banner = $counterer_grid/counterer_banner
onready var counter = $counterer_grid/counterer_role

onready var actor = $actor_grid/actor
onready var actor_banner = $actor_grid/actor_banner
onready var action_used = $actor_grid/actor_role

############################### Functions ######################################
# We'll probably update the history with a signal. But it'll refresh the pictograms and text.
#func _update_history(history):
#	pass
var card_icon_img: Dictionary = {
	Card.CARD_TYPE.CAPTAIN: preload("res://resources/Icons/icon_capitaine.png"),
	Card.CARD_TYPE.ASSASSIN: preload("res://resources/Icons/icon_assassin.png"),
	Card.CARD_TYPE.CONTESSA: preload("res://resources/Icons/icon_comtesse.png"),
	Card.CARD_TYPE.DUKE: preload("res://resources/Icons/icon_duchesse.png"),
	Card.CARD_TYPE.AMBASSADOR: preload("res://resources/Icons/icon_ambassadeur.png"),
	Card.CARD_TYPE.INQUISITOR: preload("res://resources/Icons/icon_inquisiteur.png"),
	0: preload("res://resources/Icons/mask_small_icon.png"),
}
var banner_icon_img: Dictionary = {
	Card.CARD_TYPE.CAPTAIN: preload("res://resources/Banners/banner_voleurs.png"),
	Card.CARD_TYPE.ASSASSIN: preload("res://resources/Banners/banner_assassins.png"),
	Card.CARD_TYPE.CONTESSA: preload("res://resources/Banners/banner_intouchables.png"),
	Card.CARD_TYPE.DUKE: preload("res://resources/Banners/banner_perceptrices.png"),
	Card.CARD_TYPE.AMBASSADOR: preload("res://resources/Banners/banner_negociateurs.png"),
	Card.CARD_TYPE.INQUISITOR: preload("res://resources/Banners/banner_negociateurs.png"),
	0: preload("res://resources/Banners/mask_banner.png"),
}
var action_icon_img: Dictionary = {
	Action.ACTION_TYPE.INCOME: preload("res://resources/Icons/icon_aide_etrangere.png"),
	Action.ACTION_TYPE.FOREIGN_AID: preload("res://resources/Icons/icon_aide_etrangere.png"),
	Action.ACTION_TYPE.COUP: preload("res://resources/Icons/icon_assassinat.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_action(action, is_first):
	update_first_action(action) if is_first else update_counter(action)
	
func update_first_action(action):
	action_used.set_texture(card_icon_img[action.get_card_type()])
	actor_banner.set_texture(banner_icon_img[action.get_card_type()])
	action_used.set_texture(action_icon_img[action.get_action_type()])
	
	match action.get_sender_id():
		1: actor.set_text(global.players[0])
		2: if global.players[1] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[1])
		3: if global.players[2] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[2])
		4: if global.players[3] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[3])
		5: if global.players[4] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[4])
		6: if global.players[5] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[5])
		7: if global.players[6] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[6])
		8: if global.players[7] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[7])
		_: pass
	pass
	
func update_counter(action):
	counter.set_texture(card_icon_img[action.get_card_type()])
	counterer_banner.set_texture(banner_icon_img[action.get_card_type()])
	counter.set_texture(action_icon_img[action.get_action_type()])
	
	match action.get_sender_id():
		1: counterer.set_text(global.players[0])
		2: if global.players[1] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[1])
		3: if global.players[2] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[2])
		4: if global.players[3] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[3])
		5: if global.players[4] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[4])
		6: if global.players[5] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[5])
		7: if global.players[6] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[6])
		8: if global.players[7] == "": actor.set_text("Player " + String(action.get_sender_id())); else: actor.set_text(global.players[7])
		_: pass
	pass

func clean_actions():
	clean_counter()
	clean_first_action()

func clean_counter():
	counter.set_texture(load("res://resources/Icons/mask_small_icon.png"))
	counterer_banner.set_texture(load("res://resources/Banners/mask_banner.png"))
	counterer.set_text("Player")

func clean_first_action():
	action_used.set_texture(load("res://resources/Icons/mask_small_icon.png"))
	actor_banner.set_texture(load("res://resources/Banners/mask_banner.png"))
	actor.set_text("Player")

