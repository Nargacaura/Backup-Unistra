extends Player_Base

class_name Player
################################################################################
#                                   SIGNALS                                    #
################################################################################
# See class Player_Base
signal resume()
"""Signal to wait for the view."""

signal make_reaction(actions)
"""
make_reaction

Signal to ask the view to make the player reaction (ex: Doubt).

:param Action action: Action made by the current player. Action to react to.
"""

signal choose_cards(cards, qty, text)
"""
choose_cards

Signal to ask the view to choose **qty** card from the **cards** Array.

:param Array cards: Array of cards to choose from.
:param int qty: Quantity of cards to choose.
:param String text: Text to display to the player.
"""

signal choose_options(options, text)
"""
choose_options

Signal to ask the view to choose an option from the **options** Array.

:param Array options: Array of options to choose from.
:param String text: Text to display to the player.
"""

signal chosen_cards(cards)
"""
chosen_cards

Signal to notify the `Board`, that the player chose the card(s).

:param Array cards: Array containing the cards indexes.
"""

signal chosen_options(options)
"""
chosen_options

Signal to notify the `Board`, that the player chose the option.

:param Array options: Array containing the chosen option index.
"""

################################################################################
#                                  ATTRIBUTES                                  #
################################################################################
# See class Player_Base

################################################################################
# Constructor
# Class : Player
# Default values :
#     id = -1 : By default invalid player id
#     username = "" : By default empty player username
func _init(id: int = -1, username: String = "", color: String = "#ffffff", roles: Array = [1, 2, 3, 4, 5]):
	_id = id if id > 0 else -1
	_username = username
	_balance = 0
	_hand = []
	_color = color
	_action = null
	_passed = false
	_roles = roles
	print("Creation of Player \"%s\" with ID: %d"%[_username, _id])

################################################################################
#                               PUBLIC FUNCTIONS                               #
################################################################################
#------------------------------------------------------------------------------#
# Game Loop function
#------------------------------------------------------------------------------#
func play_turn(players_data: Dictionary) -> void:
	"""
	play_turn
	
	Called from `Board`: Method that requests an action from a player when it's their turn to play.
	
	:param Dictionary players_data: Dictionary containing the minimum info needed to play.
	:return void: The return is made by the signal: 'player_action'.
	"""
	_action = null
	emit_signal("play_turn", self, _roles, players_data)
	yield(self, "resume")
	if _action != null:
		emit_signal("player_action", _action)

func select_cards(cards: Array, qty: int = 1, text: String = "") -> void:
	"""
	select_cards
	
	Called from `Board`: Method that requests a choice of cards from the player.
	
	:param Array cards: Array of cards to choose from.
	:param int qty: Quantity of cards to choose.
	:param String text: Text to display to the player.
	:return void: The return is made by the signal: 'player_card_choice'.
	"""
	if text == "":
		text = "Select %d card%s" % [qty, "s" if qty > 1 else ""]
	var selection : Array = []
	emit_signal("choose_cards", cards, qty, text)
	while selection.size() != qty:
		selection = yield(self, "chosen_cards")
	emit_signal("player_card_choice", selection)

func branch_options(options: Array, text: String) -> void:
	"""
	branch_options
	
	Called from `Board`: Method that requests a player to pick an option in a list.
	
	:param Array options: Array of options to choose from.
	:param String text: Text to display to the player.
	:return void: The return is made by the signal: 'player_option_choice'.
	"""
	emit_signal("choose_options", options, text)
	var selection : Array = []
	selection = yield(self, "chosen_options")
	emit_signal("player_option_choice", selection)

func request_kill_card(text: String = "", qty: int = 1) -> void:
	"""
	request_kill_card
	
	Called from `Board`: Method that requests a victim from the player.
	
	:param String text: Text to display to the player.
	:param int qty: Quantity of cards to kill.
	:return void: The return is made by the signal: 'player_card_choice'.
	"""
	var cards : Array = []
	var selection : Array
	for card in _hand:
		cards.push_back(card)
	emit_signal("choose_cards", cards, qty, text)
	selection = yield(self, "chosen_cards")
	emit_signal("player_card_choice", selection)

################################################################################
#                              PRIVATE FUNCTIONS                               #
################################################################################
#------------------------------------------------------------------------------#
# Signals Functions
#------------------------------------------------------------------------------#
func _on_start_reaction(calling_action: Action) -> void:
	"""
	_on_start_reaction
	
	Called from `Board`: Method that ask the view to make a reaction.
	
	:param Action calling_action: Action made by the current player. Action to react to.
	:return void: The return is made by the signal: 'player_reaction'.
	"""
	_passed = false
	if calling_action._sender_id == _id or !is_alive():
		emit_signal("end_turn")
		return
	_action = null
	if !calling_action._can_be_countered and !calling_action._can_be_doubted:
		return
	emit_signal("make_reaction", calling_action, _roles)
	yield(self, "resume")
	emit_signal("player_reaction", _action)

func _on_end_reaction() -> void:
	"""
	_on_end_reaction
	
	Called from `Board`: Method to tell the view to stop reaction.
	
	:return void:
	"""
	emit_signal("end_reaction")

func _on_end_turn() -> void:
	"""
	_on_end_turn
	
	Called from `Board`: Method to tell the view it is the end of the turn.
	
	:return void:
	"""
	emit_signal("end_turn")

func _on_choose_action(action_type: int = Action.ACTION_TYPE.INCOME, card_type: int = 0, targets_id: Array = [0]) -> void:
	"""
	_on_choose_action
	
	Called from View: 
	
	:param int action_type:
	:param int card_type:
	:param Array targets_id:
	:return void:
	"""
	print(action_type)
	print(targets_id)
	if targets_id == []:
		targets_id = [0]
	_action = Action.new(action_type, get_id(), targets_id, card_type)
	emit_signal("resume")

func _on_choose_cards(cards: Array) -> void:
	"""
	_on_choose_cards
	
	Called from View: 
	
	:param Array cards:
	:return void:
	"""
	emit_signal("chosen_cards", cards)

func _on_choose_options(options: Array) -> void:
	"""
	_on_choose_options
	
	Called from View: 
	
	:param Array cards:
	:return void:
	"""
	emit_signal("chosen_options", options)

func _on_reaction(action_type: int, calling_action: Action, card_type: int) -> void:
	"""
	_on_reaction
	
	Called from View: 
	
	:param int action_type:
	:param Action calling_action:
	:param int card_type:
	:return void:
	"""
	print(action_type)
	emit_signal("player_reaction", Action.new(action_type, _id, [calling_action._sender_id], card_type))

################################################################################
# LINK TO THE INTERFACE
################################################################################
func connect_signals(view: Node) -> void:
	"""
	connect_signals
	
	Method to link all needed signals between the player and its view. 
	
	:param Node view: Node that represents the player.
	:return void:
	"""
	var _s # Top with the warnings for surefire events
	########################################################################
	# CORE SIGNALS ALL MUST BE IMPLEMENTED TO LET PLAYER PLAY THE GAME
	########################################################################
	# Core: Signal called when it's the player turn, the player instance is
	# passed along
	_s = self.connect("play_turn", view, "_on_play_turn")
	# Core: Respond to signal "play_turn",
	# must return : action_type, card_type, targets
	_s = view.connect("choose_action", self, "_on_choose_action")
	# Core: Signal that ask the player to choose <qty> number of card inside
	# the <cards> array by displaying the text <text>
	_s = self.connect("choose_cards", view, "_on_choose_cards")
	# Core; Respond to signal "choose_cards",
	# must return : an array containing <qty> selected cards
	_s = view.connect("choose_cards", self, "_on_choose_cards")
	# Core: Signal that ask the player to pick an option in the
	# array <options> by displaying the text <text>
	# (exemple of use: Inquisitor second ability)
	_s = self.connect("choose_options", view, "_on_choose_options")
	# Core: Respond to signal "choose_options",
	# must return : an array containing the selected option
	_s = view.connect("choose_options", self, "_on_choose_options")
	# Core: Signal to let the player react to the current player's action,
	# calling_action is passed along
	_s = self.connect("make_reaction", view, "_on_make_reaction")
	# Core: Respond to "make_reaction" signal,
	# must return : action_type, calling_action, card_type
	_s = view.connect("reaction", self, "_on_reaction")
	# Core: Function to call when finishing adding / removing / killing a
	# player card
	_s = view.connect("hand_updated", self, "_on_hand_updated")
	########################################################################
	# View Signals
	########################################################################
	# Interface: Signal when a player card has just been killed (update visual)
	_s = self.connect("kill_card", view, "_on_kill_card")
	# Interface: Signal called when the player is ready (when he received his coins)
	_s = self.connect("init_player", view, "_on_init_player")
	# Interface: Signal called when player balance is changed (update visual)
	_s = self.connect("change_balance", view, "_on_change_balance")
	# Interface: Signal called when a card is added to the player hand
	_s = self.connect("add_card", view, "_on_add_card")
	# Interface: Signal called when a card is removed from the player hand
	_s = self.connect("remove_card", view, "_on_remove_card")
	# Interface: Signal called when the player cannot react anymore to the current action
	_s = self.connect("end_reaction", view, "_on_end_reaction")
	# Interface: Signal called when it's the end of the player's turn
	_s = self.connect("end_turn", view, "_on_end_turn")
	# Interface: Signal when the action is sent to the board (you can disable action selection)
	_s = self.connect("player_action", view, "_on_player_action")
	# Interface: Signal to hide player reaction screen (or disable reaction buttons)
	_s = self.connect("stop_reaction", view, "_on_stop_reaction")
