extends "res://addons/gut/test.gd"

################################################################################
# Class : TestBoardConstructor
class TestBoardConstructor:
	extends "res://addons/gut/test.gd"
	
	var Board = load("res://scripts/core/Board.gd")
	var _board = null
	
	func before_each():
		pass
	
	func after_each():
		pass
	
	func before_all():
		pass
	
	func after_all():
		pass
	
	func test_empty_constructor():
		_board = Board.new()
		assert_is(_board, Board)
		assert_eq(_board._player_count, -1)
		assert_eq(_board._players, [])
		assert_eq(_board._deck, [])
	#	assert_eq(_board._valid_cards, [0, 1, 1, 1, 1, 1, 0])
		assert_eq(_board._actions, [])
		assert_eq(_board._active_player_id, 1)
		_board = null
	
	func test_bad_constructors():
		# Bad player count
		_test_constructor(-5, -1)
		_test_constructor(-1, -1)
		_test_constructor(0, -1)
		_test_constructor(1, -1)
		_test_constructor(9, -1)
		_test_constructor(10, -1)
		# Ambassador and Inquisitor
		_test_constructor(5, 5, [0, 1, 1, 1, 1, 1, 1], [0, 1, 1, 1, 1, 1, 0])
		# Not enought cards
		_test_constructor(5, 5, [0, 1, 1, 1, 1, 0, 0], [0, 1, 1, 1, 1, 1, 0])
		
	
	
	
	func _test_constructor(_player_count: int, _result_player_count: int, _roles: Array = [0, 1, 1, 1, 1, 1, 0], _result_roles: Array = [0, 1, 1, 1, 1, 1, 0]):
		_board = Board.new(_player_count, _roles)
		assert_is(_board, Board)
		assert_eq(_board._player_count, _result_player_count)
		assert_eq(_board._players, [])
		assert_eq(_board._deck, [])
		assert_eq(_board._actions, [])
		assert_eq(_board._active_player_id, 1)
		_board = null
	
################################################################################
# Class : TestBoardFunctions

class TestBoardFunctions:
	extends "res://addons/gut/test.gd"
	var Board = load("res://scripts/core/Board.gd")
	var Player = load("res://scripts/core/Player.gd")
	var Card = load("res://scripts/core/Card.gd")
	var _card = null
	var _board = null
	var _player = null
	
	func before_each():
		pass
	
	func after_each():
		pass
	
	func before_all():
		pass
	
	func after_all():
		pass
	
	func test_add_player():
		var player_count: int = 5
		_board = Board.new(player_count, [0, 1, 1, 1, 1, 1, 0 ])
		# Invalid ID must be set to a valid player id
		var player: Player = Player.new(0, "Player_test")
		# add_player must return the new valid player id
		assert_eq(_board.add_player(player), 1)
		assert_eq(_board._players.size(), 1)
		# Player id must be set to the first valid id available
		assert_eq(player.get_id(), 1)
		# Adding the rest of the players
		for i in range(2, player_count + 1):
			assert_eq(_board.add_player(Player.new(i, "Player_test")), i)
			assert_eq(_board._players.size(), i)
			assert_eq(_board._players[i - 1].get_id(), i)
		# Adding too much players, add_player must return -1 ...
		assert_eq(_board.add_player(Player.new(6, "Player_test")), -1)
		# ... and must not add the player
		assert_eq(_board._players.size(), player_count)
		_board = null
	
	func test_is_game_over():
		_board = Board.new(5,[0, 1, 1, 1, 1, 1, 0 ])
		_player = Player.new( 5, "Player_test1" ) 
		_player.add_card( Card.new( Card.CARD_TYPE.DUKE ) )
		# If there is no players, game is over
		assert_true(_board.is_game_over())
		_board.add_player( _player )
		# If there is only one player, game is over
		assert_true(_board.is_game_over())
		_board.add_player( Player.new( 1, "Player_test"  ))
		_board.add_player( Player.new( 2, "Player_test"  ))
		# If there are more than one player but only one is alive, game is over
		assert_true(_board.is_game_over())
		_board.add_player( _player )
		# If there are more than one alive player, game is not over
		assert_false(_board.is_game_over())
	
