extends Control

export(Array, Vector2) var players_positions = [
	Vector2(1517, 457),
	Vector2(2027, 374),
	Vector2(2015, 652),
	Vector2(1377, 777),
	Vector2(1544, 1073),
	Vector2(413, 480),
	Vector2(756, 1113),
	Vector2(2662, 1254)
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

var players_nodes: Array = []

func _ready():
	players_nodes = get_children()
	_place_players()

func _place_players() -> void:
	for i in players_nodes.size():
		players_nodes[i].rect_position = players_positions[i]
