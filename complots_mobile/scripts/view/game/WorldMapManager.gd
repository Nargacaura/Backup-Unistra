extends TextureRect

export(PackedScene) var Player_scene = null

export(Array, Vector2) var players_positions = [
	Vector2(1517, 517),
	Vector2(2077, 434),
	Vector2(2015, 712),
	Vector2(1377, 837),
	Vector2(1544, 1133),
	Vector2(413, 540),
	Vector2(756, 1173),
	Vector2(2662, 1314)
]

export(Array, Array, Vector2) var players_cards_offsets = [
	[Vector2(-147, 45), Vector2(166, 45)],
	[Vector2(-207, 91), Vector2(323, 65)],
	[Vector2(-217, 67), Vector2(329, 72)],
	[Vector2(-125, 18), Vector2(223, 60)],
	[Vector2(-76, -63), Vector2(4, 200)],
	[Vector2(-103, 166), Vector2(255, 25)],
	[Vector2(-96, -92), Vector2(31, 224)],
	[Vector2(-133, 40), Vector2(119, -202)]
]

export(Array, Color) var players_colors = [
	Color("#39b54a"),
	Color("#29abe2"),
	Color("#b33939"),
	Color("#d9e021"),
	Color("#f7931e"),
	Color("#2c2c54"),
	Color("#c69c6d"),
	Color("#93278f")
]

export(Array, Array, int, "Europe", "Russia", "Asia", "North Africa", "South Africa", "North America", "South America", "Australia") var players_combinaison_positions

onready var lands: Array = $Lands.get_children()
onready var players_container: Node = $Players_Anchor
var player_count: int
var players: Array = []
var game_manager: Node = null

# UI
var drag_position = null
var scales: Array = [
	1.0,
	1.2,
	1.4,
	1.6,
	1.8,
	2.0,
]
var zoom_level: int = 0
var min_zoom_level: int = 0
var max_zoom_level: int = scales.size() - 1

var _ret # To Stop Warnings


#############
# TO REMOVE
var test_player_count: int = 2
#############

func _ready():
	_ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	players_colors = AppManager.players_colors


func init_game(_players: Array) -> void:
	players = _players
	_place_players(players)
	game_manager.end_reaction_phase()


func _place_players(_players: Array) -> void:
	for land in lands:
		land.hide()
	
	player_count = players.size()
	for i in player_count:
		if Player_scene:
			var player_view = Player_scene.instance()
			players_container.add_child(player_view)
			player_view.rect_position = players_positions[players_combinaison_positions[player_count - 2][i]]
			player_view.set_balance(0)
			player_view.is_bot = players[i] is Bot
			player_view._id = i + 1
			player_view.set_color(players_colors[players_combinaison_positions[player_count - 2][i]])
			player_view.place_cards(players_cards_offsets[players_combinaison_positions[player_count - 2][i]])
			lands[players_combinaison_positions[player_count - 2][i]].show()
			# Connecting Player instance with its view
			if AppManager.is_singleplayer:
				players[i].connect_signals(player_view)
			else:
				players[i].connect_signals_core_to_view(player_view)
				
			game_manager.get_coup_button().connect("pressed", player_view, "_on_action_pressed", [Action.ACTION_TYPE.COUP, Card.CARD_TYPE.HIDDEN])
			game_manager.get_pass_button().connect("pressed", player_view, "_on_reaction_pressed", [Action.ACTION_TYPE.PASS, Card.CARD_TYPE.HIDDEN])
			game_manager.get_doubt_button().connect("pressed", player_view, "_on_reaction_pressed", [Action.ACTION_TYPE.DOUBT, Card.CARD_TYPE.HIDDEN])
			player_view.game_manager = game_manager
			if !AppManager.is_singleplayer and AppManager.player_game_id == player_view._id:
				AppManager.multiplayer_data["player_view"] = player_view


func get_player_color(_player_id, _player_count) -> Color:
	return players_colors[players_combinaison_positions[_player_count - 2][_player_id]]


func link_target(player_view: Node, callback: String, target_id: int) -> void:
	for player_node in players_container.get_children():
		if player_node._id == target_id:
			player_node.emit_particles(true)
			if !player_node.is_connected("pressed", player_view, callback):
				player_node.connect("pressed", player_view, callback, [target_id])
			break


func unlink_all_targets(player_view: Node, callback: String) -> void:
	for player_node in players_container.get_children():
		player_node.emit_particles(false)
		if player_node.is_connected("pressed", player_view, callback):
			player_node.disconnect("pressed", player_view, callback)

################################################################################
# UI Camera Controller
func _on_World_Map_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Start dragging
			drag_position = get_global_mouse_position() - rect_global_position
			# Zoom In
			if event.button_index == BUTTON_WHEEL_UP:
				_zoom_map(1, drag_position)
			# Zoom Out
			if event.button_index == BUTTON_WHEEL_DOWN:
				_zoom_map(-1, drag_position)
		else:
			# Stop dragging
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
		_clamp_map_position()


func _zoom_map(increment: int, zoom_position: Vector2) -> void:
	var previous_zoom_level: int = zoom_level
	
	zoom_level += increment
	zoom_level = int(min(zoom_level, max_zoom_level))
	zoom_level = int(max(zoom_level, min_zoom_level))
	
	# If zoom level changed
	if zoom_level != previous_zoom_level:
		var scale_factor: float = scales[zoom_level] / scales[previous_zoom_level]
		var offset: Vector2 = (zoom_position) * scale_factor - zoom_position
		rect_scale = Vector2.ONE * scales[zoom_level]
		rect_global_position -= offset
		_clamp_map_position()


func _clamp_map_position() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var chat_width: int = 0
	if game_manager:
		chat_width = game_manager.get_chat_width()
	
	# Coord X
	if rect_global_position[0] > 0:
		rect_global_position[0] = 0
	if rect_global_position[0] < (-rect_size[0] * rect_scale[0]) + viewport_size[0] - chat_width:
		rect_global_position[0] = (-rect_size[0] * rect_scale[0]) + viewport_size[0] - chat_width
	
	# Coord Y
	if rect_global_position[1] > 0:
		rect_global_position[1] = 0
	if rect_global_position[1] < (-rect_size[1] * rect_scale[1]) + viewport_size[1]:
		rect_global_position[1] = (-rect_size[1] * rect_scale[1]) + viewport_size[1]
	
	# If Viewport is bigger than the map
	if viewport_size[0] - chat_width > (rect_size[0] * rect_scale[0]):
		rect_global_position[0] = (-rect_size[0] * rect_scale[0]) / 2 + viewport_size[0] / 2
	if viewport_size[1] > (rect_size[1] * rect_scale[1]):
		rect_global_position[1] = (-rect_size[1] * rect_scale[1]) / 2 + viewport_size[1] / 2


func _on_window_resize() -> void:
	_clamp_map_position()
