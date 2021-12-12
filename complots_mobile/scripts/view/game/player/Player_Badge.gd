extends TextureButton

export(Color) var player_color = Color(0, 0, 0)

onready var player_face: Node = $Player_Face


func _ready():
	update_player_color()


func set_player_color(color: Color) -> void:
	player_color = color
	update_player_color()


func update_player_color() -> void:
	self.self_modulate = player_color
	player_face.self_modulate = player_color
