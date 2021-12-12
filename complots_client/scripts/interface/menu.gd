extends Control
############################# MAIN MENU ########################################

########################### Nodes acquired #####################################
# Buttons
onready var quit_button = $GridContainer/quit_button
onready var about_button = $GridContainer/about_button
onready var join_button = $GridContainer/TabContainer/Join/join_grid/join_button
onready var create_button = $GridContainer/TabContainer/Create/create_button
onready var login_button = $GridContainer/TabContainer/Login/Buttons/box_aligner/login_button
onready var register_button = $GridContainer/TabContainer/Login/Buttons/box_aligner_2/register_button

# Inputs
onready var options = $GridContainer/TabContainer/Create/create_grid/choice_option
onready var server_input = $GridContainer/TabContainer/Create/create_grid/server_name_input
onready var join_server = $GridContainer/TabContainer/Join/join_grid/server_name_input

onready var id_login = $GridContainer/TabContainer/Login/login_register/login_box/login_grid/id_input
onready var pwd_login = $GridContainer/TabContainer/Login/login_register/login_box/login_grid/pwd_input

onready var username_register = $GridContainer/TabContainer/Login/login_register/register_box/register_grid/username_input
onready var id_register = $GridContainer/TabContainer/Login/login_register/register_box/register_grid/id_input
onready var pwd_register = $GridContainer/TabContainer/Login/login_register/register_box/register_grid/pwd_input
onready var verif_pwd_register = $GridContainer/TabContainer/Login/login_register/register_box/register_grid/verif_input

onready var language = $GridContainer/TabContainer/Settings/settings_grid/change_language
onready var sound = $GridContainer/TabContainer/Settings/settings_grid/volume/sound_value
onready var sound_slider = $GridContainer/TabContainer/Settings/settings_grid/volume/change_volume

onready var popup = $Infos

onready var log_info = $GridContainer/TabContainer/Login/log_info

var lst_server_scene = preload("res://scenes/server_lst_unit.tscn")
var lst_server = lst_server_scene.instance()
# Input variables (for use in the numeral input -- unused yet)
var wrong_input = Color(255, 0, 0)
var acceptable_input = Color(0, 255, 0)

############################### Functions ######################################
# Called when the node enters the scene tree for the first time.
func _ready():
	Network.connect_menu(self)
	$GridContainer/TabContainer/Join/list_container.add_child(lst_server)
	# Adds remaining card choices
	# If stable version finished: try to make multi-selective card sets
	options.add_item("Ambassador", null, true)
	options.add_item("Inquisitor", null, true)
	
	# Adds language options
	# TODO: translate everything in all the other locales
	#		(or delete them if undone)
	language.add_item("English", null, true)
	#language.add_item("French", null, true)
	#language.add_item("Spanish", null, true)
	#language.add_item("Turkish", null, true)
	#language.add_item("Russian", null, true)
	#language.add_item("Bulgarian", null, true)
	
	# Sets default settings (as for now)
	# TODO: fetch previously saved settings in a file
	sound_slider.set_value(global.default_sounds)
	sound.set_text(String(global.default_sounds))

# Confirm the choices
func ambassador():
	global.choice = 1
#	if player_input.is_anything_selected():
	create_button.set_disabled(false)

func inquisitor():
	global.choice = 2
#	if player_input.is_anything_selected():
	create_button.set_disabled(false)

# Reset the choices
func reset_choise():
	global.choice = -1
	global.nb_players = 8
	create_button.set_disabled(true)

# Quit the game on button pressed
func _on_quit_button_pressed():
	get_tree().quit()

# to login
func _on_login_button_pressed():
	var id = id_login.get_text()
	var pwd = pwd_login.get_text()
	if id == "" or pwd == "":
		log_info.text = "You must fill in the fields"
		return
	Network.connect_login(id, pwd)

# Register new account
func _on_register_button_pressed():
	var id = id_register.get_text()
	var pwd = pwd_register.get_text()
	var username = username_register.get_text()
	var verif = verif_pwd_register.get_text()
	if id == "" or pwd == "" or username == "" or verif == "":
		log_info.text = "You must fill in the fields"
		return
	elif verif != pwd:
		log_info.text = "Password does not match"
		return
	else:
		Network.create_login(id, pwd, username)

# Join the server on button pressed
func _on_join_button_pressed():
	Network.join_game(int(join_server.get_text()))
#	if get_tree().change_scene("res://scenes/Lobby.tscn") != OK:
#		print ("An unexpected error occured when trying to switch to the Lobby scene")

# Begin hosting the server on button pressed
func _on_create_button_pressed():
	# Put your name and the server's name onto the lobby
	global.server_name = server_input.get_text()
	if global.server_name == "":
		global.server_name = "Nameless"
	# Sets the server's roles
	global.roles = [Card.CARD_TYPE.DUKE,
		Card.CARD_TYPE.ASSASSIN,
		Card.CARD_TYPE.CONTESSA,
		Card.CARD_TYPE.CAPTAIN,
		null]
	if global.choice == 1:
		global.roles[4] = Card.CARD_TYPE.AMBASSADOR
	else:
		global.roles[4] = Card.CARD_TYPE.INQUISITOR
	if options.is_anything_selected() :
		Network.create_game(global.server_name,global.roles)
	else:
		pass	
	# Get to the lobby screen
	
func _on_connect_game(room,id,name,roles):
	global.my_id = id
	global.roles = roles
	global.server_name = name+" id:"+str(room)
	var _s = get_tree().change_scene("res://scenes/Lobby.tscn")

# Returns infos after login or registration
func _on_update_log(_res,_data):
	print("result")
	global.your_username = _data
	if _res == true:
		log_info.text = "Registered, "+_data
	else:
		log_info.text = "Unregistered, "+_data

# Show informations about the game
func _on_about_button_pressed():
	popup.popup_centered(Vector2(1033, 1033))

# Sets the remaining card
func _on_choice_option_item_selected(id):
	match id:
		0: ambassador()
		1: inquisitor()
		_: reset_choise()
	print(id)

# Changes the volume's overall value
func _on_change_volume_value_changed(value):
	sound.set_text(str(value))

#only allow digit values	
# to fix : I don't know how to remove the last inputed character so I assumed it was the last character of the string. Hence there are issues if we don't type at the end of the string
func _on_sound_value_text_changed(new_text):
	#if a non digit value is typed
	if !new_text.is_valid_integer():
		#the last character is removed
		sound.set_text(sound.text.substr(0, sound.text.length()-1))
		#the caret is set to the end
		sound.set_cursor_position(sound.text.length())
	#restrict the values to the interval [0, 100]
	if int(new_text) > 100:
		sound.set_text("100")
		sound.set_cursor_position(sound.text.length())

#when you change the label the slider changes too
func _on_sound_value_text_entered(new_text):
	sound_slider.set_value(int(new_text))

# Resets the settings to default
func _on_reset_button_pressed():
	sound_slider.set_value(global.default_sounds)
	sound.set_text(String(global.default_sounds))

# Set the number of available seats for the server
func _on_player_count_input_item_selected(index):
	global.nb_players = index + 2 # choice index converted to number of seats
	if options.is_anything_selected():
		create_button.set_disabled(false)

func _on_games_list(data):
	lst_server.add_list(data)


func _on_Button_pressed():
	Network.get_games_list()
