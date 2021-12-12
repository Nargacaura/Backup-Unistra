extends ColorRect

onready var btn: Button = $Button
onready var room_text_label: Label = $MarginContainer/Content/RoomText
onready var player_count_label: Label = $MarginContainer/Content/PlayerCount

var id: int = -1
var room_name: String = "Room name"
var room_creator: String = "Creator"
var player_count: int = 0

func _ready():
	var _ret = btn.connect("pressed", self, "_on_pressed")
	set_room_id(id)
	set_room_name(room_name)
	set_room_creator(room_creator)
	set_player_count(player_count)


func set_room_id(_room_id: int) -> void:
	id = _room_id
	update_room_text()


func set_room_name(_room_name: String) -> void:
	room_name = _room_name
	update_room_text()


func set_room_creator(_room_creator: String) -> void:
	room_creator = _room_creator
	update_room_text()


func update_room_text() -> void:
	room_text_label.text = "%s | %s | ID: %d" % [room_name, room_creator, id]
	player_count_label.text = "%d/8" % [player_count]


func get_room_text() -> String:
	return room_text_label.text


func set_player_count(_player_count: int) -> void:
	player_count = _player_count
	player_count_label.text = "%d/8" % [_player_count]


func connect_pressed(node_to_connnect: Node, callback: String) -> void:
	if !btn.is_connected("pressed", node_to_connnect, callback):
		var _ret = btn.connect("pressed", node_to_connnect, callback, [self])


func set_pressed(status: bool) -> void:
	btn.pressed = status


func _on_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
