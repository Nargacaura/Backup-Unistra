extends HBoxContainer

signal pressed_reaction()

var balance: int
var _selected_card: int
var _selected_action: int

onready var counter = $counter_container/counter_button # Stop one's action
onready var doubt = $counter_container/doubt_button # Unmask the truth about the act
onready var pass_button = $counter_container/pass_button # Do nothing


var roles_texture = {
	Card.CARD_TYPE.DUKE : preload("res://resources/Icons/icon_duchesse.png"),
	Card.CARD_TYPE.ASSASSIN : preload("res://resources/Icons/icon_assassin.png"),
	Card.CARD_TYPE.CONTESSA : preload("res://resources/Icons/icon_comtesse.png"),
	Card.CARD_TYPE.CAPTAIN : preload("res://resources/Icons/icon_capitaine.png"),
	Card.CARD_TYPE.AMBASSADOR : preload("res://resources/Icons/icon_ambassadeur.png"),
	Card.CARD_TYPE.INQUISITOR : preload("res://resources/Icons/icon_inquisiteur.png"),
	0: preload("res://resources/Icons/mask_small_icon.png"),
}

var roles_texture_disabled = {
	Card.CARD_TYPE.DUKE : preload("res://resources/Icons/icon_duchesse_disabled.png"),
	Card.CARD_TYPE.ASSASSIN : preload("res://resources/Icons/icon_assassin_disabled.png"),
	Card.CARD_TYPE.CONTESSA : preload("res://resources/Icons/icon_comtesse_disabled.png"),
	Card.CARD_TYPE.CAPTAIN : preload("res://resources/Icons/icon_capitaine_disabled.png"),
	Card.CARD_TYPE.AMBASSADOR : preload("res://resources/Icons/icon_ambassadeur_disabled.png"),
	Card.CARD_TYPE.INQUISITOR : preload("res://resources/Icons/icon_inquisiteur_disabled.png")
}

var black = preload("res://resources/Icons/mask_small_icon.png")

signal hud_action_selected

func _ready():
	activate_roles(false)
	activate_main_actions(false)

func connect_buttons(parent):
	var enrich = get_node("actions_grid/enrich_button")
	var stranger = get_node("actions_grid/stranger_button")
	var assassinate = get_node("actions_grid/assassinate_button")

	for i in 5:
		var button = get_node("Abilities/abilities_container/role_"+str(i+1)+"_button")
		#attribute a specific action to each button (is made dynamicaly, depend of roles)
		var action = card_to_action(global.roles[i])
		button.connect("pressed",parent,"_on_action_pressed",[action,global.roles[i]])
	enrich.connect("pressed",parent,"_on_action_pressed",[Action.ACTION_TYPE.INCOME])
	stranger.connect("pressed",parent,"_on_action_pressed",[Action.ACTION_TYPE.FOREIGN_AID])
	assassinate.connect("pressed",parent,"_on_action_pressed",[Action.ACTION_TYPE.COUP])


func activate_roles(set: bool, only_roles: Array = []):
	if set:
		for i in 5:
			var button = get_node("Abilities/abilities_container/role_"+str(i+1)+"_button")
			var all_roles: bool = (only_roles == [])
			var is_exception: bool = (global.roles[i] in only_roles)
			#if it's the contessa, display a disable icon
			if global.roles[i] == Card.CARD_TYPE.CONTESSA:
				if !all_roles and is_exception:
					button.set_normal_texture(roles_texture[global.roles[i]])
					button.set_disabled(false)
				else:
					button.set_normal_texture(roles_texture_disabled[global.roles[i]])
					button.set_disabled(true)
				continue
			#if you don't have enough money, assassin can't be called
			if global.roles[i] == Card.CARD_TYPE.ASSASSIN:
				if balance < 3: #if you don't have enough money
					button.set_normal_texture(roles_texture_disabled[global.roles[i]])
					button.set_disabled(true)
				else: #if you have
					button.set_normal_texture(roles_texture[global.roles[i]] if (all_roles or is_exception) else roles_texture_disabled[global.roles[i]])
					button.set_disabled(!(all_roles or is_exception))
				continue
			#general icon change
			button.set_normal_texture(roles_texture[global.roles[i]] if (all_roles or is_exception) else roles_texture_disabled[global.roles[i]])
			button.set_disabled(!(all_roles or is_exception))
	else:
		for i in 5:
			var button = get_node("Abilities/abilities_container/role_"+str(i+1)+"_button")
			button.set_normal_texture(roles_texture_disabled[global.roles[i]])
			button.set_disabled(true)

func activate_main_actions(activate: bool):
	var enrich = get_node("actions_grid/enrich_button")
	var stranger = get_node("actions_grid/stranger_button")
	var assassinate = get_node("actions_grid/assassinate_button")

	enrich.set_disabled(not activate)
	stranger.set_disabled(not activate)
	#if you don't have enough money you can't assassinate
	if balance < 7 :
		assassinate.set_disabled(true)
	else :
		assassinate.set_disabled(not activate)

func update_balance(val):
	balance = val
	$actions_grid/gold_counter.set_text(str(balance))

func card_to_action(card_type):
	match card_type:
		Card.CARD_TYPE.AMBASSADOR :
			return Action.ACTION_TYPE.AMBASSADOR
		Card.CARD_TYPE.ASSASSIN :
			return Action.ACTION_TYPE.ASSASSIN
		Card.CARD_TYPE.CAPTAIN :
			return Action.ACTION_TYPE.CAPTAIN
		Card.CARD_TYPE.CONTESSA :
			return Action.ACTION_TYPE.CONTESSA
		Card.CARD_TYPE.DUKE :
			return Action.ACTION_TYPE.DUKE
		Card.CARD_TYPE.INQUISITOR :
			return Action.ACTION_TYPE.INQUISITOR_1
		_:
			return Action.ACTION_TYPE.INCOME

func disable_reactions():
	counter.set_disabled(true)
	doubt.set_disabled(true)
	pass_button.set_disabled(true)

func _on_counter_button_pressed():
	disable_reactions()
	emit_signal("pressed_reaction", Action.ACTION_TYPE.COUNTER)

func _on_doubt_button_pressed():
	disable_reactions()
	emit_signal("pressed_reaction", Action.ACTION_TYPE.DOUBT)

func _on_pass_button_pressed():
	disable_reactions()
	emit_signal("pressed_reaction", Action.ACTION_TYPE.PASS)
