extends Node

signal choose_action
signal choose_cards
signal choose_options
signal reaction
signal announcement_update
signal action_selected_from_hud
signal target_selected(id)
signal turn_position(id)
signal update_chat(username,text)
signal counter_selected(card_type)

var pos = {
	0:Vector2(100*0.67,880*0.715),
	1:Vector2(744*0.67,543*0.715),
	2:Vector2(982*0.67,362*0.715),
	3:Vector2(744*0.67,181*0.715),
	4:Vector2(506*0.67,30*0.715),
	5:Vector2(268*0.67,181*0.715),
	6:Vector2(30*0.67,362*0.715),
	7:Vector2(268*0.67,543*0.715)
	}

var user_place = {
	2:{0:pos[0],1:pos[4]},
	3:{0:pos[0],1:pos[3],2:pos[5]},
	4:{0:pos[0],1:pos[2],2:pos[4],3:pos[6]},
	5:{0:pos[0],1:pos[1],2:pos[3],3:pos[5],4:pos[7]},
	6:{0:pos[0],1:pos[1],2:pos[3],3:pos[4],4:pos[5],5:pos[7]},
	7:{0:pos[0],1:pos[1],2:pos[2],3:pos[3],4:pos[5],5:pos[6],6:pos[7]},
	8:{0:pos[0],1:pos[1],2:pos[2],3:pos[3],4:pos[4],5:pos[5],6:pos[6],7:pos[7]}
}
var player_scene = preload("res://scenes/Player_scene.tscn")
var HUD_scene = preload("res://scenes/HUD_scene.tscn")
var historic_scene = preload("res://scenes/history_scene.tscn")
var chat_scene = preload("res://scenes/Chat.tscn")
var card_selector_scene = preload("res://scenes/Card_selector_scene.tscn")
var timer_scene = preload("res://scenes/Timer_scene.tscn")
var game_over_popup = preload("res://scenes/GameOverPopup.tscn")

var players = []

var hud = HUD_scene.instance()
var historic = historic_scene.instance()
var chat = chat_scene.instance()
var card_select = card_selector_scene.instance()
var game_over = game_over_popup.instance()
var timer_node = timer_scene.instance()
var called_action
var _action_type
var _card_type

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

func _ready():
###  TEST  ###
#	global.my_id = 2
#	global.roles = [1,2,3,4,6]
#	global.nb_players = 8
#	global.players = ['user','user','user','user','user','user','user','user']
	Network.connect_signals(self)
	var screen = OS.get_screen_size(0)
	hud.rect_position = Vector2(450*0.67,880*0.715)
	historic.rect_position = Vector2(1215*0.67,650*0.715)
	chat.rect_position = Vector2(1300*0.67,50*0.715)
	timer_node.set_position(Vector2(1200*0.67,800*0.715))
	add_child(timer_node)
	timer_node.hide()
#	timer_node.set_process(false)
	chat.connect_chat(self)
	card_select.disable(true)
	card_select.connect_selector(self)
	hud.connect_buttons(self)
	add_child(game_over)
	_init_board(global.nb_players)

###  TEST  ###
#	hud.update_balance(7)
#	var card = Card.new()
#	card._type = Card.CARD_TYPE.AMBASSADOR
#	for i in 8:
#		players[i].add_card(card)
#	hud.activate_roles(true)
#	hud.activate_main_actions(true)
#	card_select.disable(false)
#	var card2 = Card.new()
#	card_select.add_card(card,2)
#	card_select.add_card(card,2)
#	card_select.add_card(card,2)
#	card_select.add_card(card,2)
#	card_select.add_card(card,2)

func _init_board(player_count):
	add_child(historic)
	add_child(hud)
	hud.connect("pressed_reaction",self,"_on_choosed_reaction")
	add_child(chat)
	add_child(card_select)
	create_player(player_count)

func create_player(count):
	var p_lst =[]
	var pos = 1
	for i in 8:
		if i == global.my_id:
			p_lst.append(0)
		else :
			p_lst.append(pos)
			pos += 1

	for i in count:
		var p = player_scene.instance()
		p.set_id(i)
		print("my id : " + str(global.my_id))
		print("id : " + str(i)+" pos :" + str(p_lst[i]))
		p.rect_position = user_place[count][p_lst[i]]
		p.rect_min_size = Vector2(300*0.67,0)
		p.set_username(global.players[i])
		p.connect_buttons(self)
		$Board_node.add_child(p)
		players.append(p)
	players[global.my_id].hide_stat(true)

func update_action(action: Action, is_first: bool):
	if action.get_action_type() == Action.ACTION_TYPE.PASS:
		return
	var actor = historic.get_node("actor_grid/actor" if is_first else "counterer_grid/counterer")
	var banner = historic.get_node("actor_grid/actor_banner" if is_first else "counterer_grid/counterer_banner")
	var role = historic.get_node("actor_grid/actor_role" if is_first else "counterer_grid/counterer_role")
	if action.get_card_type() in hud.roles_texture:
		role.set_texture(hud.roles_texture[action.get_card_type()])
	if action.get_card_type() in banner_icon_img:
		banner.set_texture(banner_icon_img[action.get_card_type()])
	if action.get_action_type() in action_icon_img:
		role.set_texture(action_icon_img[action.get_action_type()])

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

func clean_actions():
	clean_counter()
	clean_first_action()

func clean_counter():
	var actor = historic.get_node("counterer_grid/counterer")
	var banner = historic.get_node("counterer_grid/counterer_banner")
	var role = historic.get_node("counterer_grid/counterer_role")
	role.set_texture(load("res://resources/Icons/mask_small_icon.png"))
	banner.set_texture(load("res://resources/Banners/mask_banner.png"))
	actor.set_text("Player")

func clean_first_action():
	var actor = historic.get_node("actor_grid/actor")
	var banner = historic.get_node("actor_grid/actor_banner")
	var role = historic.get_node("actor_grid/actor_role")
	role.set_texture(load("res://resources/Icons/mask_small_icon.png"))
	banner.set_texture(load("res://resources/Banners/mask_banner.png"))
	actor.set_text("Player")

#######################################################################
######################## Signal functions  ############################
#######################################################################

################################ Tested ##################################
func _on_play_turn(player: Player_Base, roles: Array, players_data: Dictionary):
	print_debug(player._id, " turn")
	global.roles = roles
	_action_type = null
	called_action = null

	hud.activate_main_actions(true)
	hud.activate_roles(true)

func _on_action_pressed(action_type:int,card_type: int = 0):
	print("action : " + str(action_type))
	if _action_type == Action.ACTION_TYPE.COUNTER and called_action != null and card_type != 0:
		emit_signal("reaction", _action_type, called_action, card_type)
		return
	var activator = [Action.ACTION_TYPE.ASSASSIN ,
			Action.ACTION_TYPE.CAPTAIN,
			Action.ACTION_TYPE.COUP,
			Action.ACTION_TYPE.INQUISITOR_1]
	_action_type = action_type
	_card_type = card_type

	players[global.my_id].activate_select(card_type == Card.CARD_TYPE.INQUISITOR)
	for i in global.nb_players:
		if i != global.my_id:
			#dynamic way to disable and enable selector
			if card_type == Card.CARD_TYPE.CAPTAIN:
				players[i].activate_select(action_type in activator && players[i].balance >= 2)
			else:
				players[i].activate_select(action_type in activator)

	print("Action pressed : " +str(action_type))
	#if we don't need to select targets
	if not _action_type in activator:
		emit_signal("choose_action",
				action_type,
				card_type,
				[0])
		hud.activate_main_actions(false)
		hud.activate_roles(false)

#if an actor as been selected
func _on_selected(id):
	var targets_id = []
	if _card_type == Card.CARD_TYPE.INQUISITOR:
		if id -1 == global.my_id:
			targets_id.append(0)
			_action_type = Action.ACTION_TYPE.INQUISITOR_1
		else:
			targets_id.append(id)
			_action_type = Action.ACTION_TYPE.INQUISITOR_2
	else:
		targets_id.append(id)
	for i in global.nb_players:
		players[i].activate_select(false)
	emit_signal("choose_action",
			_action_type,
			_card_type,
			targets_id)
	timer_node.stop()
	hud.activate_main_actions(false)
	hud.activate_roles(false)

func _on_add_card(id,card: Card):
	players[id].add_card(card)

func _on_remove_card(id,card_id: int):
	players[id].remove_card(card_id)

func _on_kill_card(id,card_id: int, card_type: int, _is_alive: bool = true):
	players[id].kill_card(card_id,card_type,_is_alive)

func _on_change_balance(id,balance: int):
	print("update balance id  : " + str(id) + " balance :" + str(balance))
	players[id].update_balance(balance)
	if id == global.my_id:
		hud.update_balance(balance)

func _on_end_turn():
	called_action = null
	_action_type = null
	hud.activate_main_actions(false)
	hud.activate_roles(false)
	hud.disable_reactions()
	for i in global.nb_players:
		players[i].activate_select(false)
	timer_node.hide()

func _on_init_player(id,player: Player_Base):
	global.my_id = id
	global.roles = player._roles

func _on_choose_cards(cards: Array, qty: int, text: String):
	var selection: Array = []
	card_select.set_title(text)
	card_select.disable(false)
	for card in cards:
		card_select.add_card(card,qty)
	timer_node.trigger(30)

func _on_selection_done(selection, is_option: bool = false):
	emit_signal("choose_cards" if !is_option else "choose_options",selection)
	card_select.disable(true)
	timer_node.stop()

func _on_make_reaction(calling_action: Action, roles: Array):
	hud.disable_reactions()

	called_action = calling_action
	if hud.pass_button.is_disabled():
		toggle_action(hud.pass_button)
	if hud.counter.is_disabled() and calling_action._can_action_be_countered():
		toggle_action(hud.counter)
	if hud.doubt.is_disabled() and calling_action._can_action_be_doubted():
		toggle_action(hud.doubt)

func _on_choosed_reaction(action_type):
	print("choosed_reaction ", action_type)
	var card_type = Card.CARD_TYPE.INVALID
	if action_type == Action.ACTION_TYPE.COUNTER:
		if called_action == null:
			return
		_action_type = Action.ACTION_TYPE.COUNTER
		var counterers = Action.get_counters(called_action.get_action_type())
		hud.activate_roles(true,counterers)
	if action_type != Action.ACTION_TYPE.COUNTER or card_type != Card.CARD_TYPE.INVALID:
		print("Reacted with ", action_type, "/", card_type)
		if called_action == null:
			print("vide")
			return
		emit_signal("reaction", action_type, called_action, card_type)
		timer_node.stop()
	#_action_type = Action.ACTION_TYPE.PASS

func _on_end_reaction():
	if !hud.pass_button.is_disabled():
		toggle_action(hud.pass_button)
	if !hud.counter.is_disabled():
		toggle_action(hud.counter)
	if !hud.doubt.is_disabled():
		toggle_action(hud.doubt)
	timer_node.stop()
	emit_signal("announcement_update", "You made your choice.")
	_action_type = null
	called_action = null

func _on_stop_reaction():
	hud.disable_reactions()

func _on_choose_options(options : Array, text : String):
	var selection: Array = []
	card_select.set_title(text)
	card_select.get_child(0).show()
	var i = 0
	for option in options:
		card_select.add_option(option, i)
		i += 1
	while selection.size() != 1:
		var selected_options = yield(card_select,"selection_done")
		if selected_options.size() > 0:
			selection += selected_options
	emit_signal("choose_options", selection)
	timer_node.stop()

func toggle_action(action:Button):
	match action.is_disabled():
		false: action.set_disabled(true)
		true: action.set_disabled(false)
		_: pass # let it stay as-is.

func _on_player_action(action: Action):
	pass

func _on_start_reaction(action: Action, time: int):
	update_action(action,!(action.get_action_type() in [Action.ACTION_TYPE.COUNTER, Action.ACTION_TYPE.DOUBT]))
	if action.get_sender_id() != global.my_id + 1:
		timer_node.trigger(time)
	pass

func _on_hud_action_selected():
	emit_signal("action_selected_from_hud")

func _on_begin_turn(active_player_id: int):
	clean_actions()
	emit_signal("turn_position", active_player_id)
	if active_player_id == global.my_id + 1:
		timer_node.trigger(30)

func _on_end_game(player):
	game_over.set_winner_name(player.get_username())
	game_over.popup_centered(Vector2(200*0.67,200*0.715))
	game_over.start_timer()

func _on_target_selected(id):
	emit_signal("target_selected", id)

func _on_update_chat(username,msg):
	chat._update_chat(username,msg)

func _on_update_history(msg):
	chat._update_history(msg)
##	var chatlog = chat.get_child_by_name("messages")
#	chatlog.bbcode_text += '[b]' + username + '[/b]: '
#	chatlog.bbcode_text += msg
#	chatlog.bbcode_text += '[/color][/b]'
#	chatlog.bbcode_text += '\n'
