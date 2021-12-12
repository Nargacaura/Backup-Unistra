extends Node

const Player_Hand = preload("res://scenes/debug/PlayerHand_Test.tscn")

export(int, 0, 8) var player_count = 1
export(int, 0, 8) var bot_count = 0
export(int, "Ambassador", "Inquisitor") var card_choice
var roles: Array = []
var board: Board = null
var action_timer: Timer = null
var bluff_timer: Timer = null
var last_active_player_id: int = 0
var view: Node = null
var colors = [
	"#c0392b", # Pomegranate
	"#2980b9", # Belize Hole
	"#27ae60", # Nephritis
	"#8e44ad", # Wisteria
	"#d35400", # Pumpkin
	"#f39c12", # Orange
	"#2c3e50", # Midnight Navy
	"#16a085", # Green Sea
	]

signal update_history
signal begin_turn

func _init(node = null, nb_players = 4, nb_bots = 0):
	view = node
	player_count = nb_players
	bot_count = nb_bots
	print("New view set:", view)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	_make_roles()
	_start_game()

func _start_game() -> void:
	if board != null:
		_clean_board()
	var _s # Top with the warnings for surefire events
	print("Role value: %d" % [card_choice])
	print(roles)
	action_timer = Timer.new()
	add_child(action_timer)
	bluff_timer = Timer.new()
	add_child(bluff_timer)
	if player_count + bot_count < 2:
		player_count = 1
		bot_count = 1
	elif player_count + bot_count > 8:
		bot_count = 8 - player_count
	board = Board.new(player_count + bot_count, roles, action_timer, bluff_timer)
	# Interface: Signal to update chat with board log
	_s = board.connect("update_history", self, "_on_update_history")
	# Interface: Signal called when a new turn starts
	_s = board.connect("begin_turn", self, "_on_begin_turn")
	# Interface: Signal called when the game is over
	_s = board.connect("game_over", self, "_on_game_over")
	for i in range(1, player_count + 1):
		var player: Player = Player.new(i, "Player_%d" % [i], colors[i - 1], roles)
		if view == null:
			var player_hand = Player_Hand.instance()
			player.connect_signals(player_hand)
			player_hand._action_container = $Actions_Container
			player_hand._target_container = $Targets_Container
			player_hand._card_select_container = $Card_Select_Container
			player_hand._timer = Timer.new()
			player_hand._id = i
			player_hand.set_name(player._username)
			$Board_Container/Players.add_child(player_hand)
		else:
			player.connect_signals(view)
		_s = board.add_player(player)
	for i in range(player_count + 1, player_count + bot_count + 1):
		var bot: Bot = Bot.new(i, "Player_%d (BOT)" % [i], colors[i - 1], roles, Bot.BOT_DIFFICULTY.EASY)
		if view == null:
			var player_hand = Player_Hand.instance()
			bot.connect_signals(player_hand)
			player_hand._action_container = $Actions_Container
			player_hand._target_container = $Targets_Container
			player_hand._card_select_container = $Card_Select_Container
			player_hand._id = i
			player_hand.set_name(bot._username)
			$Board_Container/Players.add_child(player_hand)
		else:
			bot.connect_signals(view)
		_s = board.add_player(bot)
	board.run()

func _clean_board() -> void:
	for child in $Board_Container/Players.get_children():
		child.queue_free()
	$Board_Container/Sidebar/Sidebar_Grid/Text_BG/Text.text = ""

func _input(_event) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _make_roles() -> void:
	roles.push_back(Card.CARD_TYPE.DUKE)
	roles.push_back(Card.CARD_TYPE.ASSASSIN)
	roles.push_back(Card.CARD_TYPE.CONTESSA)
	roles.push_back(Card.CARD_TYPE.CAPTAIN)
	if card_choice == 0:
		roles.push_back(Card.CARD_TYPE.AMBASSADOR)
	else:
		roles.push_back(Card.CARD_TYPE.INQUISITOR)

func _on_begin_turn(_player_id) -> void:
	#$Board_Container/Players.get_child(board.get_active_player_id() - 1).get_child(1).color = Color("#4eb3c7")
	#if last_active_player_id != 0:
	#	var color = Color("#c74e4e")
	#	if !board.get_player_by_id(last_active_player_id).is_alive():
	#		color = Color("#000000")
	#	$Board_Container/Players.get_child(last_active_player_id - 1).get_child(1).color = color
	last_active_player_id = board.get_active_player_id()
	emit_signal("begin_turn", last_active_player_id)

func _on_update_history(message: String) -> void:
	if message == "":
		return
	emit_signal("update_history", message)
	#if $Board_Container/Sidebar/Sidebar_Grid/Text_BG/Text.get_text() != "":
	#	message = "\n" + message
	#$Board_Container/Sidebar/Sidebar_Grid/Text_BG/Text.append_bbcode(message)

func _on_game_over() -> void:
	#$Board_Container/Sidebar/Sidebar_Grid/Text_BG/Text.append_bbcode("\n\n%s WON THE GAME!" % [board.get_active_player().get_bbusername()])
	yield(get_tree().create_timer(2), "timeout")
	action_timer.queue_free()
	bluff_timer.queue_free()
	_clean_board()
	var _s = get_tree().reload_current_scene()

func _on_Deal_Cards_pressed() -> void:
	board._deal_cards()
