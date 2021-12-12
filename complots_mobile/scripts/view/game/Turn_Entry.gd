extends HBoxContainer

onready var player_badge: Node = $Player_Badge
onready var entry_text: Label = $Text
onready var separator: VSeparator = $Separator

export(Color) var player_color: Color = Color(0, 0, 0)
export(bool) var is_last: bool = false
export(String) var action_text: String = "Action"


func _ready() -> void:
	player_badge.set_player_color(player_color)
	_update_separator()
	set_action_text(action_text)


func set_last(last: bool) -> void:
	is_last = last
	_update_separator()


func _update_separator() -> void:
	if is_last:
		separator.hide()
	else:
		separator.show()


func set_action_text(text: String) -> void:
	action_text = text
	entry_text.text = text


func set_player_color(color: Color) -> void:
	player_color = color
	player_badge.set_player_color(color)
