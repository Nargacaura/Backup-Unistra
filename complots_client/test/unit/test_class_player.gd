extends "res://addons/gut/test.gd"

################################################################################
# Class : TestPlayerConstructor
class TestPlayerConstructor:
	extends "res://addons/gut/test.gd"
	
	var Player = load("res://scripts/core/Player.gd")
	var _player = null
	
	func before_each():
		pass
	
	func after_each():
		pass
	
	func before_all():
		pass
	
	func after_all():
		pass
	
	func test_empty_constructor():
		_player = Player.new()
		assert_is(_player, Player)
		assert_eq(_player.get_id(), -1)
		assert_eq(_player.get_username(), "")
		assert_eq(_player.get_balance(), 0)
		assert_eq(_player.get_hand(), [])
		_player = null
	
	func test_good_constructors():
		_test_constructor(1, 1, "Player_name_1")
		_test_constructor(50, 50, "Player_name_50")
	
	func test_bad_constructors():
		# Invalid ID must return -1
		_test_constructor(-5, -1)
		_test_constructor(-1, -1)
		# 0 is an invalid ID, it is reserved for the Treasure
		_test_constructor(0, -1)
	
	func _test_constructor(_input_id: int, _result_id: int, _username: String = "Player_Name"):
		_player = Player.new(_input_id, _username)
		assert_is(_player, Player)
		assert_eq(_player.get_id(), _result_id)
		assert_eq(_player.get_username(), _username)
		assert_eq(_player.get_balance(), 0)
		assert_eq(_player.get_hand(), [])
		_player = null
	

################################################################################
# Class : TestPlayerFunctions
class TestPlayerFunctions:
	extends "res://addons/gut/test.gd"
	
	var Player = load("res://scripts/core/Player.gd")
	var Card = load("res://scripts/core/Card.gd")
	var _player = null
	
	func before_each():
		_player = Player.new(1, "Player_test")
	
	func after_each():
		_player = null
	
	func before_all():
		pass
	
	func after_all():
		pass
	
	func test_player_hand():
		# Player is dead by default
		assert_true(!_player.is_alive())
		# Player has no card by default
		assert_eq(_player.get_hand().size(), 0)
		var _card = Card.new(Card.CARD_TYPE.DUKE)
		_player.add_card(_card)
		assert_eq(_player.get_hand().size(), 1)
		assert_eq(_player.get_hand(), [_card])
		assert_eq(_player.get_hand()[0], _card)
		assert_eq(_player.get_hand()[0].get_counters(), [Action.ACTION_TYPE.FOREIGN_AID])
		assert_true(_player.is_alive())
		_player.remove_card(0)
		assert_eq(_player.get_hand().size(), 0)
		_player.add_card(_card)
		assert_eq(_player.get_hand().size(), 1)

	func test_player_balance():
		# Default balance value must be 0
		assert_eq(_player.get_balance(), 0)
		# set_balance() change the player's balance to the amount,
		# it does not increment
		_player.set_balance(2)
		assert_eq(_player.get_balance(), 2)
		_player.set_balance(0)
		assert_eq(_player.get_balance(), 0)
		# Balance cannot go under 0
		_player.change_balance(-5)
		assert_eq(_player.get_balance(), 0)
		# Basic operations
		_player.change_balance(3)
		assert_eq(_player.get_balance(), 3)
		_player.change_balance(2)
		assert_eq(_player.get_balance(), 5)
		_player.change_balance(-4)
		assert_eq(_player.get_balance(), 1)
	
