class_name Player_Base
"""Inherited By: Player, Bot"""

################################################################################
#                                   SIGNALS                                    #
################################################################################
signal play_turn(player, roles, players_data)
"""
Signal: play_turn

**Game Loop** signal: Signal that ask the view to make an action.

:param Player player: The player object itself.
:param Array roles: Array containing the list of valid cards for this game.
:param Dictionary players_data: The minimum amount of info, about all players, needed to make an action.
"""

signal player_action(action)
"""
Signal: player_action

**Game Loop** signal: Signal to send player’s action to the `Board`. It is called after the view choose the action.

:param Action action: The action made by the player.
"""

signal player_card_choice(cards)
"""
Signal: player_card_choice

**Game Loop** signal: Signal to ask the view to choose a card from the card **Array**.

:param Array cards: The list of cards indexes to choose from.
"""

signal player_option_choice(option)
"""
Signal: player_option_choice

**Game Loop** signal: Signal to ask the view to choose an option from the options **Array**.

:param Array options: The list of options to choose from.
"""

signal player_reaction(action)
"""
Signal: player_reaction

**Reaction** signal: Signal emitted from _on_start_reaction, to let the player react to the **action**.

:param Action action: The action to react to.
"""

signal end_reaction()
"""**Reaction** signal: Signal called when the player cannot react anymore to the current action."""

signal init_player(player)
"""
Signal: init_player

**View** signal: Signal to init the player’s view with the player’s data.

:param Player player: The player object itself.
"""

signal add_card(card)
"""
Signal: add_card

**View** signal: Signal to notify the view to add a card in player’s hand.

:param Card card: The card to add to the player's hand visual.
"""

signal remove_card(card_id)
"""
Signal: remove_card

**View** signal: Signal to notify the view to remove the card of index **card_id** in player’s hand.

:param int card_id: The index of the card to remove from the player's hand visual.
"""

signal kill_card(card_index, card_type, is_alive)
"""
Signal: kill_card

**View** signal: Signal to notify the view to kill the card of index **card_index** in player’s hand.

:param int card_index: The index of the card to kill from the player's hand visual.
:param int card_type: The type of the card to kill.
:param bool is_alive: ``true`` if the player is alive else ``false``.
"""

signal change_balance(balance)
"""
Signal: change_balance

**View** signal: Signal to notify the view to change player’s balance.

:param int balance: The player's balance.
"""

signal hand_updated()
"""**View** signal: Signal to notify the `Board` that the player’s hand was updated."""

signal end_turn()
"""**View** signal: Signal to notify the view that the turn has ended."""

signal stop_reaction()
"""**View** signal: Signal to notify the view that the player cannot react anymore."""

################################################################################
#                                  ATTRIBUTES                                  #
################################################################################
var _id: int
"""A unique number to identify the player."""

var _username: String
"""The username of the player."""

var _balance: int
"""The amount of coins of the player."""

var _hand: Array # Elements of type: Card
"""The player’s hand composed of two cards."""

var _action: Action = null
"""The current action of the player."""

var _color: String
"""Each player has a color to make it easier to identify the players."""

var _passed: bool
"""Boolean to check if the player has passed the current action."""

var _roles: Array = []
"""List of all available roles in the current game."""

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
# Called from Board: Custom Setters
#------------------------------------------------------------------------------#
func set_balance(amount: int) -> void:
	"""
	Method: set_balance
	
	Setter of the property _balance.
	
	:param int amount:
	:return void:
	"""
	_balance = amount
	emit_signal("change_balance", _balance)
	emit_signal("init_player", self)

func change_balance(amount: int) -> void:
	"""
	Method: change_balance
	
	Method to increase or decrease the player’s _balance.
	
	:param int amount:
	:return void:
	"""
	_balance += amount
	if _balance < 0:
		_balance = 0
	emit_signal("change_balance", _balance)

func add_card(card: Card) -> void:
	"""
	Method: add_card
	
	Method to add a card to the player’s _hand.
	
	:param Card card:
	:return void:
	"""
	print("add_card")
	emit_signal("add_card", card)
	_hand.push_back(card)

func remove_card(index: int) -> void:
	"""
	Method: remove_card
	
	Method to remove the card at position **index** from the player’s hand.
	
	:param int index:
	:return void:
	"""
	print("remove_card %d" % [index])
	emit_signal("remove_card", index)
	_hand.remove(index)

func stop_reaction() -> void:
	"""
	Method: stop_reaction
	
	Method to let the player know he cannot react to the current action anymore.
	
	:return void:
	"""
	emit_signal("stop_reaction")

#------------------------------------------------------------------------------#
# Game Loop function
#------------------------------------------------------------------------------#
func play_turn(_players_data: Dictionary) -> void:
	"""
	Method: play_turn
	
	The main method for the player to make his action. The method is called by the `Board`.
	
	:param Dictionary player_data: This is the minimum amount of data about the players needed to make an action.
	:return void:
	"""
	# emit_signal("player_action", _action)
	pass # Must be implemented in child classes

func kill_card(card_index: int) -> void:
	"""
	Method: kill_card
	
	Method called by the `Board` to tell the player he has lost the card of position **card_index**.
	
	:param int card_index:
	:return void:
	"""
	get_hand()[card_index].kill()
	emit_signal("kill_card", card_index, get_hand()[card_index].get_type(), is_alive())

func select_cards(_cards: Array, _qty: int = 1, _text: String = "") -> void:
	"""
	Method: select_cards
	
	Method called by the `Board` to ask the player to select **qty** cards form the **cards** Array. A message is passed with it in the variable **text**.
	
	:param Array cards:
	:param int qty:
	:param String text:
	:return void:
	"""
	# emit_signal("player_card_choice", selection) # selection is an array
	pass # Must be implemented in child classes

func branch_options(_options: Array, _text: String) -> void:
	"""
	Method: branch_options
	
	Method called by the `Board` to ask the player to select an option form the **options** Array. A message is passed with it in the variable **text**.
	
	:param Array options:
	:param String text:
	:return void:
	"""
	# emit_signal("player_option_choice", selection) # selection is an array
	pass # Must be implemented in child classes

func request_kill_card(_text: String = "", _qty: int = 1) -> void:
	"""
	Method: request_kill_card
	
	Method called by the `Board` to ask the player to kill **qty** cards form the player's hand.
	
	:param String text:
	:param Array qty:
	:return void:
	"""
	# emit_signal("player_card_choice", selection) # selection is an array
	pass # Must be implemented in child classes

################################################################################
#                              PRIVATE FUNCTIONS                               #
################################################################################
#------------------------------------------------------------------------------#
# Signals Functions
#------------------------------------------------------------------------------#
func _on_start_reaction(_calling_action: Action) -> void:
	"""
	Method: _on_start_reaction
	
	Method called by the `Board` to ask the player to make a reaction to the current action.
	
	:param Action calling_action:
	:return void:
	"""
	# emit_signal("player_reaction", _action)
	pass # Must be implemented in child classes

func _on_end_reaction() -> void:
	"""
	Method: _on_end_reaction
	
	Method called by the `Board` to tell the player’s view to stop displaying the reaction screen.
	
	:return void:
	"""
	emit_signal("end_reaction")

func _on_end_turn() -> void:
	"""
	Method: _on_end_turn
	
	Method called by the `Board` to tell the player’s view that the turn has ended.
	
	:return void:
	"""
	emit_signal("end_turn")

func _on_resolved_action(_resolved_action: Action) -> void:
	"""
	Method: _on_resolved_action
	
	Method called by the `Board` used by the Bots to update the _game_data.
	
	:param Action resolved_action:
	:return void:
	"""
	pass

func _on_player_loose_card(_player_id: int, _card_type: int) -> void:
	"""
	Method: _on_player_loose_card
	
	Method called by the `Board` used by the Bots to update the _game_data.
	
	:param Action resolved_action:
	:return void:
	"""
	pass

func _on_hand_updated() -> void:
	"""
	Method: _on_hand_updated
	
	Method called by the player’s view to let the `Board` know that the player’s hand was updated.
	
	:return void:
	"""
	emit_signal("hand_updated")

################################################################################
#                                   GETTERS                                    #
################################################################################
func get_id() -> int:
	return _id

func get_username() -> String:
	return _username

func get_bbusername() -> String:
	return "[color=" + _color + "]" + _username + "[/color]"

func get_balance() -> int:
	return _balance

func get_hand() -> Array:
	return _hand

func get_actions() -> Array:
	var actions: Array = []
	for card in _hand:
		if !card.is_dead():
			actions.push_back(card.get_type())
	return actions

func has_card(card_type: int) -> bool:
	for card in _hand:
		# If card is not dead and it's the good type
		if !card.is_dead() and card.get_type() == card_type:
			return true
	return false

func has_passed() -> bool:
	return _passed

# Helper function
func is_alive() -> bool:
	for card in _hand:
		if not card.is_dead():
			return true
	return false

#------------------------------------------------------------------------------#
# Debug Functions
#------------------------------------------------------------------------------#
func _print() -> void:
	"""
	Method: _print
	
	Debug method to print the player’s info in the console.
	
	:return void:
	"""
	print("Printing \"%s\":"%_username)
	print("  Coins: " + str(get_balance()))
	print("  Hand:")
	for card in _hand:
		print("    %s[%s]" % ["Dead" if card.is_dead() else "", card.get_name()])
	print(" ")

#------------------------------------------------------------------------------#
# Function to stop warnings
#------------------------------------------------------------------------------#
func __stop_warnings_please() -> void:
	emit_signal("play_turn")
	emit_signal("player_action")
	emit_signal("player_card_choice")
	emit_signal("player_option_choice")
	emit_signal("player_reaction")
	emit_signal("hand_updated")
