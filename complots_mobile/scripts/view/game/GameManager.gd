extends Control

export(AudioStream) var background_music = null

# Panels
onready var help_panel: Node = $Help_Panel
onready var pause_panel: Node = $Pause_Panel

# Buttons
onready var help_button: Button = $Header/Buttons/Help_Button
onready var help_button_back: Button = $Help_Panel/CenterContainer/RulesContent.back_btn
onready var pause_button: Button = $Header/Buttons/Pause_Button

# Game Nodes
onready var world_map: Node = $World_Map
onready var turn_manager: Node = $Header
onready var chat_manager: Node = $Chat_Container
onready var action_manager: Node = $Action_Bar
onready var action_buttons_container: Node = $Action_Bar/Buttons
onready var action_container: Node = $Action_Bar/Contrainer/Actions_Container
onready var bluff_container: Node = $Action_Bar/Bluffs_Container
onready var card_selection_panel: Node = $CardSelectionPanel
export(PackedScene) var Action_Button = null

# Core
var board: Board = null
var players: Array = []
var roles: Array = []
var action_timer: Timer = null
var bluff_timer: Timer = null
var player_username: String
var _id: int = 1

var player_count: int = 3
var bot_difficulty: int = Bot.BOT_DIFFICULTY.EASY
export(bool) var use_ambassador = true

var _ret # To Stop Warnings


func _ready():
	setup_game()
	init_game()


func setup_game() -> void:
	_ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	if background_music:
		AudioManager.play_music(background_music)
	
	hide_node(action_container)
	hide_node(bluff_container)
	hide_node(help_panel)
	hide_node(pause_panel)
	hide_node(card_selection_panel)
	_ret = help_button.connect("pressed", self, "_on_Help_Button_pressed")
	_ret = help_button_back.connect("pressed", self, "_on_Help_Button_Back_pressed")
	_ret = pause_button.connect("pressed", self, "_on_Pause_Button_pressed")
	
	_id = AppManager.player_game_id
	
	create_timers()
	
	if AppManager.is_singleplayer:
		singleplayer_setup()
	else:
		multiplayer_setup()
	
	# Managers SetUp
	chat_manager.game_manager = self
	world_map.game_manager = self
	turn_manager.game_manager = self
	turn_manager.timer = action_timer
	chat_manager.player_username = player_username
	chat_manager.player_color = world_map.get_player_color(_id - 1, player_count)


func create_timers() -> void:
	# Create timers
	action_timer = Timer.new()
	add_child(action_timer)
	bluff_timer = Timer.new()
	add_child(bluff_timer)


func singleplayer_setup() -> void:
	randomize()
	player_username = AppManager.user_data["login"]["username"]
	player_count = AppManager.user_data["game-config"]["player_count"]
	bot_difficulty = AppManager.user_data["game-config"]["bot_difficulty"]
	use_ambassador = AppManager.user_data["game-config"]["use_ambassador"]


func multiplayer_setup() -> void:
	player_username = AppManager.multiplayer_data["username"]
	player_count = AppManager.multiplayer_data["player_count"]
	use_ambassador = Card.CARD_TYPE.AMBASSADOR in AppManager.multiplayer_data["roles"]


func init_game() -> void:
	if AppManager.is_singleplayer:
		_init_game()
	else:
		init_multiplayer_game()
	
	_on_window_resize()


func init_multiplayer_game() -> void:
	board = Remote_Board.new(player_count, roles, action_timer, bluff_timer)
	Network.connect_signals(board)
	_ret = Network.connect("update_history", self, "_on_update_history")
	_ret = board.connect("begin_turn", self, "_on_begin_turn")
	_ret = board.connect("game_over", self, "_on_game_over")
	_ret = board.connect("end_turn", self, "_on_end_turn")
	_ret = board.connect("begin_timer", self, "_on_multiplayer_begin_timer")
	_ret = Network.connect("update_chat", board, "_on_update_chat")
	_ret = board.connect("update_chat", chat_manager, "_on_update_chat")
	
	for i in range(1, player_count + 1):
		var player: Player = Player.new(i, AppManager.multiplayer_data["players_usernames"][i - 1], "#%s" % world_map.get_player_color(i - 1, player_count).to_html(), roles)
		
		if i == _id:
			_ret = player.connect("change_balance", turn_manager, "set_balance")
		players.append(player)
		_ret = board.add_player(player)
	
	world_map.init_game(players)
	board.connect_network_view(AppManager.multiplayer_data["player_view"])


func _on_multiplayer_begin_timer(timer_node: Node) -> void:
	turn_manager.timer = timer_node


################################################################################
# UI
################################################################################
func add_action_button(action_type: int, card_type: int, calling_node: Node, callback: String, is_bluff: bool = false, display_lie_text: bool = false) -> void:
	var action_node: Button = Action_Button.instance()
	if action_type == Action.ACTION_TYPE.COUNTER:
		action_node.text = "%s %s" % [Localization.get("action.counter_with"), Localization.get(Card.get_localized_key(card_type))]
		if display_lie_text:
			action_node.text = "[Bluff] " + action_node.text
	else:
		action_node.text = Localization.get(Action.get_localized_key(action_type))
	_ret = action_node.connect("pressed", calling_node, callback, [action_type, card_type])
	if is_bluff:
		action_node.align = Button.ALIGN_RIGHT
		bluff_container.add_child(action_node)
	else:
		action_node.align = Button.ALIGN_LEFT
		action_container.add_child(action_node)


func clear_action_buttons() -> void:
	for child in action_container.get_children():
		child.queue_free()
	for child in bluff_container.get_children():
		child.queue_free()
	set_active_actions(false)


func hide_select_menu() -> void:
	card_selection_panel.hide_select_menu()


func set_active_actions(status: bool) -> void:
	action_manager.set_active_actions(status)


func set_active_coup(status: bool) -> void:
	action_manager.set_active_coup(status)


func enable_counter() -> void:
	action_manager.enable_counter()


func enable_doubt() -> void:
	action_manager.enable_doubt()


func get_coup_button() -> Node:
	return action_manager.coup_button


func get_pass_button() -> Node:
	return action_manager.pass_button


func get_doubt_button() -> Node:
	return action_manager.doubt_button


func move_screen(move_offset: int) -> void:
	if get_viewport_rect().size[0] < abs(move_offset * 2):
		turn_manager.margin_left -= move_offset
		action_manager.margin_left -= move_offset
	turn_manager.margin_right -= move_offset
	action_manager.margin_right -= move_offset


func reset_screen_margin() -> void:
	turn_manager.margin_left = 0
	turn_manager.margin_right = 0
	action_manager.margin_left = 0
	action_manager.margin_right = 0


func is_chat_open() -> bool:
	return chat_manager.is_chat_open


func get_chat_width() -> int:
	return chat_manager.chat_width if chat_manager.is_chat_open else 0


func _on_window_resize() -> void:
	reset_screen_margin()
	if get_viewport_rect().size[0] > abs(chat_manager.chat_width * 2):
		chat_manager.open_chat()
	else:
		chat_manager.close_chat()

func _on_chat_toggled() -> void:
	world_map._clamp_map_position()

################################################################################
# Signal Callbacks
################################################################################
func _on_Help_Button_pressed():
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	if AppManager.is_singleplayer:
		get_tree().paused = !get_tree().paused
	
	if help_panel.visible:
		hide_node(help_panel)
	else:
		display_node(help_panel)


func _on_Help_Button_Back_pressed() -> void:
	if AppManager.is_singleplayer:
		get_tree().paused = false
	
	hide_node(help_panel)


func _on_Pause_Button_pressed():
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	toggle_pause()


func toggle_pause() -> void:
	if AppManager.is_singleplayer:
		get_tree().paused = !get_tree().paused
	
	if pause_panel.visible:
		hide_node(pause_panel)
	else:
		display_node(pause_panel)

################################################################################
# Helping Methods
################################################################################
func hide_node(node: Node) -> void:
	node.hide()
	node.set_process(false)

func display_node(node: Node) -> void:
	node.set_process(true)
	node.show()

################################################################################
# Core
################################################################################
func _init_game() -> void:
	_make_roles()
	
	# Create Board and connect few signals
	board = Board.new(player_count, roles, action_timer, bluff_timer)
	_ret = board.connect("update_history", self, "_on_update_history")
	_ret = board.connect("begin_turn", self, "_on_begin_turn")
	_ret = board.connect("game_over", self, "_on_game_over")
	_ret = board.connect("resolved_action", self, "_on_resolved_action")
	_ret = board.connect("update_player_view", self, "update_hand_view")
	_ret = board.connect("end_turn", self, "_on_end_turn")
	_ret = board.connect("distribution_complete", self, "_on_distribution_complete")
	
	# Create the real player
	var player: Player = Player.new(1, player_username, "#%s" % world_map.get_player_color(0, player_count).to_html(), roles)
	_ret = player.connect("change_balance", turn_manager, "set_balance")
	players.append(player)
	_id = board.add_player(player)
	
	# Create bots
	for i in range(1, player_count):
		var bot: Bot = Bot.new(i + 1, "BOT_%d" % [i], "#%s" % world_map.get_player_color(i, player_count).to_html(), roles, bot_difficulty)
		players.append(bot)
		_ret = board.add_player(bot)
	
	world_map.init_game(players)
	board.run()


func _on_update_history(message: String, action: Action) -> void:
	if message != "":
		chat_manager.add_message("[b][color=#84817a]Game Log:[/color][/b] %s" % message)
	if action:
		turn_manager.add_action_history(action, board.get_player_by_id(action.get_sender_id()))


func game_over(has_won: bool = true) -> void:
	action_timer.stop()
	bluff_timer.stop()
	if has_won:
		pause_panel.set_text("You won the game!")
		AppManager.user_data["sec-global-achievements"]["values"]["total_win_count"]["value"][0] += 1
	else:
		pause_panel.set_text("You loose the game.")
	pause_panel.hide_continue()
	AppManager.user_data["sec-global-achievements"]["values"]["total_game_count"]["value"][0] += 1
	AppManager.save_user_data()
	display_node(pause_panel)
 

func _on_game_over(winning_player: Player_Base) -> void:
	print("Winning player's id: ", winning_player.get_id())
	print("Your player's id: ", _id)
	game_over(winning_player.get_id() == _id)


func _on_begin_turn(_active_player_id: int) -> void:
	turn_manager.timer = action_timer
	var active_player: Player_Base = board.get_player_by_id(_active_player_id)
	turn_manager.new_turn(active_player)
	update_hand_view(board.get_player_by_id(_id))


func _on_distribution_complete() -> void:
	hide_select_menu()


func _make_roles() -> void:
	roles.push_back(Card.CARD_TYPE.DUKE)
	roles.push_back(Card.CARD_TYPE.ASSASSIN)
	roles.push_back(Card.CARD_TYPE.CONTESSA)
	roles.push_back(Card.CARD_TYPE.CAPTAIN)
	if use_ambassador:
		roles.push_back(Card.CARD_TYPE.AMBASSADOR)
	else:
		roles.push_back(Card.CARD_TYPE.INQUISITOR)


func start_reaction_phase() -> void:
	turn_manager.timer = bluff_timer
	action_manager.start_reaction_phase()


func set_view_bluftimer() -> void:
	turn_manager.timer = bluff_timer


func end_reaction_phase() -> void:
	set_active_actions(false)
	set_active_coup(false)
	action_manager.end_reaction_phase()


func add_card_to_view(card_text: String, player_hand: Array) -> void:
	action_manager.add_card(card_text, player_hand)


func remove_card_from_view(card_index: int) -> void:
	action_manager.remove_card(card_index,  board.get_player_by_id(_id).get_hand())


func kill_card_from_view(card_index: int) -> void:
	action_manager.kill_card(card_index)


func update_hand_view(player: Player_Base) -> void:
	action_manager.update_hand_view(player.get_hand())


func _on_end_turn() -> void:
	hide_select_menu()
	update_hand_view(board.get_player_by_id(_id))


func link_target(player_view: Node, callback: String, target_id: int) -> void:
	world_map.link_target(player_view, callback, target_id)


func unlink_all_targets(player_view: Node, callback: String) -> void:
	world_map.unlink_all_targets(player_view, callback)


func show_select_menu(cards: Array, qty: int, text: String, select_type: int, calling_node: Node, callback: String) -> void:
	card_selection_panel.show_select_menu(cards, qty, text, select_type, calling_node, callback)


func show_select_option_menu(options: Array, text: String, _card_type: int, calling_node: Node, callback: String) -> void:
	card_selection_panel.show_select_menu(options, 1, text, Action.SELECT_TYPE.KEEP, calling_node, callback, ["Leave them", "Return to Court"])


# Update player achievements
func _on_resolved_action(action: Action) -> void:
	if action.get_sender_id() != _id:
		return
	
	match action.get_action_type():
		Action.ACTION_TYPE.DOUBT:
			AppManager.user_data["sec-global-achievements"]["values"]["total_successful_doubt_count"]["value"][0] += 1
		Action.ACTION_TYPE.COUNTER:
			AppManager.user_data["sec-global-achievements"]["values"]["total_successful_counter_count"]["value"][0] += 1
		Action.ACTION_TYPE.INCOME:
			AppManager.user_data["sec-global-achievements"]["values"]["total_coin_count"]["value"][0] += 1
		Action.ACTION_TYPE.FOREIGN_AID:
			AppManager.user_data["sec-global-achievements"]["values"]["total_coin_count"]["value"][0] += 2
		Action.ACTION_TYPE.COUP:
			AppManager.user_data["sec-global-achievements"]["values"]["total_coup_count"]["value"][0] += 1
		Action.ACTION_TYPE.DUKE:
			AppManager.user_data["sec-global-achievements"]["values"]["total_coin_count"]["value"][0] += 3
			AppManager.user_data["sec-character-achievements"]["values"]["duke"]["value"][0] += 1
		Action.ACTION_TYPE.ASSASSIN:
			AppManager.user_data["sec-character-achievements"]["values"]["assassin"]["value"][0] += 1
		Action.ACTION_TYPE.CONTESSA:
			AppManager.user_data["sec-character-achievements"]["values"]["contessa"]["value"][0] += 1
		Action.ACTION_TYPE.AMBASSADOR:
			AppManager.user_data["sec-character-achievements"]["values"]["ambassador"]["value"][0] += 1
		Action.ACTION_TYPE.INQUISITOR_1:
			AppManager.user_data["sec-character-achievements"]["values"]["inquisitor_1"]["value"][0] += 1
		Action.ACTION_TYPE.INQUISITOR_2:
			# TODO: Check if player let keep the card of made it return to the Court
			pass
		_:
			pass
	
	match action.get_action_type():
		Action.ACTION_TYPE.COUNTER,\
		Action.ACTION_TYPE.DUKE,\
		Action.ACTION_TYPE.ASSASSIN,\
		Action.ACTION_TYPE.CONTESSA,\
		Action.ACTION_TYPE.AMBASSADOR,\
		Action.ACTION_TYPE.INQUISITOR_1,\
		Action.ACTION_TYPE.INQUISITOR_2:
			if !board.get_player_by_id(action.get_sender_id()).has_card(action.get_card_type()):
				AppManager.user_data["sec-global-achievements"]["values"]["total_successful_lie_count"]["value"][0] += 1
		_:
			pass
	
	AppManager.save_user_data()
