extends Node
################################ CHATBOX #######################################

########################### Nodes acquired #####################################
onready var chatLog = $messages # Output
onready var inputField = $input # Input

############################### Variables ######################################
# temporary variable used as arg in _on_input_text_entered(new_text) functiom
# will be replaced by username getter when kernel is linked
var user_name = global.players[global.my_id] # TODO: fetch other players' name

############################ Colors variables ##################################
# temporary variable used in _add_message(username, new_text) function used to
# highlight the username according to their position
# in the list gathered from the lobby
# TODO: try to replace these with global.colors[i]?
var user_name_color = '#26d221' # will be renamed host_color
var player_2_color = '#1f82cf'
var player_3_color = '#711fcf'
var player_4_color = '#cf1f3c'
var player_5_color = '#cf361f'
var player_6_color = '#cf881f'
var player_7_color = '#4f4f4e'
var player_8_color = '#ffffff'

var history_color = '#c7ba9b'

var mouse_outside_of_input_line = false

############################### Functions ######################################
# Called when the node enters the scene tree for the first time.
func _ready():
#	load("scripts/core/Board.gd").connect("update_history", self, "_update_history")
	pass
func _input(event):
	if event is InputEventMouseButton:
		if mouse_outside_of_input_line == true \
		and event.button_index == BUTTON_LEFT:
			inputField.release_focus()
## debug for _update_history() will be replaced by 'signal' from core
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_H:
#			_update_history()

# ? which parameters core sends
func _update_history(update_history_text):
	chatLog.bbcode_text += '[center][b][color=' + history_color + ']'
	chatLog.bbcode_text += update_history_text
	chatLog.bbcode_text += '[/color][/b]'
	chatLog.bbcode_text += '\n'

func _update_chat(username, new_text):
	chatLog.bbcode_text += '[b][color=' + user_name_color + ']'
	chatLog.bbcode_text += username + '[/color][/b]: '
	chatLog.bbcode_text += new_text
	chatLog.bbcode_text += '\n'

func connect_chat(view):
	view.connect("update_chat",self,"_update_chat")

func _on_input_text_entered(new_text):
	if new_text != '':
		#_update_chat(user_name, new_text)
		inputField.text = ''
		Network.update_chat(user_name, new_text)

func _on_input_mouse_exited():
	mouse_outside_of_input_line = true
func _on_input_mouse_entered():
	mouse_outside_of_input_line = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
